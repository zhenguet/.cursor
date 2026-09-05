[CmdletBinding()]
param(
  [string]$Root = (Join-Path $PSScriptRoot '..\..')
)

$ErrorActionPreference = 'Stop'
$rootPath = [System.IO.Path]::GetFullPath($Root)
$promptPath = Join-Path $rootPath 'prompts'
$skillsPath = Join-Path $rootPath 'skills'
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Assert-PathExists {
  param([string]$Path, [string]$Label)
  if (-not (Test-Path -LiteralPath $Path)) {
    $errors.Add("Missing $Label`: $Path")
  }
}

# Kernel, canonical workflow owners, contracts, and executable validators.
@(
  'AGENTS.md'
  'prompts/frontend.md'
  'prompts/backend.md'
  'prompts/backend-node.md'
  'prompts/reference-crosscheck.md'
  'prompts/review-output-baseline.md'
  'prompts/security-baseline.md'
  'prompts/testing.md'
  'prompts/project-init.md'
  'prompts/project-init-fe.md'
  'prompts/project-init-be.md'
  'prompts/project-init-split.md'
  'prompts/project-init-contract.md'
  'prompts/ui-design-to-code.md'
  'prompts/frontend-vercel-skills.md'
  'skills/ui-design-validator/SKILL.md'
  'skills/ui-interaction-contract/SKILL.md'
  'skills/cross-layer-contract/SKILL.md'
  'skills/backend-contract-validation/SKILL.md'
  'skills/backend-state-transition/SKILL.md'
  'contracts/ui-design-contract.schema.json'
  'contracts/cross-layer-contract.schema.json'
  'scripts/ui/validate-design-contract.ps1'
  'scripts/cross-layer/validate-contract.ps1'
  'scripts/backend/validate-state-contract.ps1'
) | ForEach-Object {
  Assert-PathExists (Join-Path $rootPath $_) $_
}

# Discover installed skills from the current synced tree.
$installedSkillNames = @{}
if (Test-Path -LiteralPath $skillsPath) {
  Get-ChildItem -LiteralPath $skillsPath -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName 'SKILL.md'
    if (Test-Path -LiteralPath $skillFile) {
      $installedSkillNames[$_.Name] = $skillFile
    }
  }
}

# Prevent prompt self-routing such as `project-init.md` referencing itself.
Get-ChildItem -LiteralPath $promptPath -Filter '*.md' -File | ForEach-Object {
  $file = $_
  $text = Get-Content -LiteralPath $file.FullName -Raw
  $base = [System.IO.Path]::GetFileName($file.Name)
  $quotedBase = '`' + $base + '`'
  if ($text.Contains($quotedBase)) {
    $errors.Add("Self-reference detected in prompt: $($file.Name)")
  }
}

# Validate references to prompts owned by this repository. References to the target
# workspace, skills, generated reports, and context files belong to other validators.
$nonPromptMarkdownReferences = @(
  'AGENTS.md'
  'SKILL.md'
  'CONTEXT.md'
  'CONTEXT-MAP.md'
)

Get-ChildItem -LiteralPath $promptPath -Filter '*.md' -File | ForEach-Object {
  $file = $_
  $text = Get-Content -LiteralPath $file.FullName -Raw
  $matches = [regex]::Matches($text, '`([^`\r\n]+\.md)`')
  foreach ($match in $matches) {
    $name = $match.Groups[1].Value.Trim()

    if (
      $nonPromptMarkdownReferences -contains $name -or
      $name -like '*.plan.md' -or
      $name -like '@.cursor/*' -or
      $name -like '.cursor/*' -or
      $name -like 'graphify-out/*' -or
      $name -like '*/SKILL.md' -or
      $name -like '*/*SKILL.md'
    ) {
      continue
    }

    # Paths are workspace-relative; bare filenames are prompt-directory references.
    if ($name -match '[/\\]') {
      $candidate = Join-Path $rootPath $name
    } else {
      $candidate = Join-Path $promptPath $name
    }

    if (-not (Test-Path -LiteralPath $candidate)) {
      $errors.Add("Broken prompt reference in $($file.Name): $name")
    }
  }
}

# Explicit skill-path references must resolve after every upstream sync.
$instructionFiles = @(
  (Join-Path $rootPath 'AGENTS.md')
) + @(Get-ChildItem -LiteralPath $promptPath -Filter '*.md' -File | Select-Object -ExpandProperty FullName)

foreach ($filePath in $instructionFiles) {
  if (-not (Test-Path -LiteralPath $filePath)) { continue }
  $text = Get-Content -LiteralPath $filePath -Raw

  $pathMatches = [regex]::Matches($text, '(?:@\.cursor/)?skills/([A-Za-z0-9_-]+)/SKILL\.md')
  foreach ($match in $pathMatches) {
    $skillName = $match.Groups[1].Value
    if (-not $installedSkillNames.ContainsKey($skillName)) {
      $errors.Add("Broken skill reference in $([System.IO.Path]::GetFileName($filePath)): $skillName")
    }
  }
}

# Build the set of explicitly referenced skill names from backtick references.
$referencedSkills = @{}
foreach ($filePath in $instructionFiles) {
  if (-not (Test-Path -LiteralPath $filePath)) { continue }
  $text = Get-Content -LiteralPath $filePath -Raw
  $tokens = [regex]::Matches($text, '`([A-Za-z0-9][A-Za-z0-9_-]*)`')
  foreach ($token in $tokens) {
    $name = $token.Groups[1].Value
    if ($installedSkillNames.ContainsKey($name)) {
      $referencedSkills[$name] = $true
    }
  }
}

# Report intentionally unreachable skills as warnings rather than failing the workspace.
# Many skills are user-invoked, operational, educational, or runtime-specific.
$unreferencedSkills = $installedSkillNames.Keys | Where-Object { -not $referencedSkills.ContainsKey($_) } | Sort-Object
if ($unreferencedSkills.Count -gt 0) {
  $warnings.Add("Skills not directly referenced by AGENTS.md/prompts: $($unreferencedSkills -join ', ')")
}

# Lightweight prompt-size guardrails. These are maintainability thresholds, not token limits.
$sizeLimits = @{
  'AGENTS.md' = 30000
  'prompts/frontend.md' = 8000
  'prompts/backend.md' = 8000
  'prompts/backend-node.md' = 8000
  'prompts/security-baseline.md' = 8000
  'prompts/project-init.md' = 5000
  'prompts/project-init-fe.md' = 5000
  'prompts/project-init-be.md' = 6000
  'prompts/project-init-split.md' = 7000
  'prompts/project-init-contract.md' = 5000
  'prompts/ui-design-to-code.md' = 6000
}

foreach ($entry in $sizeLimits.GetEnumerator()) {
  $path = Join-Path $rootPath $entry.Key
  if (Test-Path -LiteralPath $path) {
    $length = (Get-Item -LiteralPath $path).Length
    if ($length -gt $entry.Value) {
      $errors.Add("Prompt exceeds size guardrail: $($entry.Key) ($length > $($entry.Value) bytes)")
    }
  }
}

# Canonical ownership smoke checks.
$ownershipChecks = @(
  @('prompts/review-output-baseline.md', 'severity|finding bar|invariant falsification')
  @('prompts/reference-crosscheck.md', 'Implementation Risk Contract|counterexamples|verification mapping')
  @('prompts/security-baseline.md', 'authentication|authorization|security verification')
  @('prompts/ui-design-to-code.md', 'Design Contract|ui-design-validator|frontend.md')
  @('prompts/project-init-split.md', 'orchestration workflow|child workflows|API contract')
)

foreach ($check in $ownershipChecks) {
  $relative = $check[0]
  $path = Join-Path $rootPath $relative
  if (Test-Path -LiteralPath $path) {
    $text = (Get-Content -LiteralPath $path -Raw).ToLowerInvariant()
    $patterns = $check[1].Split('|')
    foreach ($pattern in $patterns) {
      if ($text -notlike "*$($pattern.ToLowerInvariant())*") {
        $errors.Add("Canonical ownership smoke check failed: $relative missing '$pattern'")
      }
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Host 'Workspace prompt validation: FAIL'
  $errors | ForEach-Object { Write-Host "- $_" }
  if ($warnings.Count -gt 0) {
    Write-Host 'Warnings:'
    $warnings | ForEach-Object { Write-Host "- $_" }
  }
  exit 1
}

Write-Host 'Workspace prompt validation: PASS'
Write-Host "Prompts checked: $((Get-ChildItem -LiteralPath $promptPath -Filter '*.md' -File).Count)"
Write-Host "Installed skills discovered: $($installedSkillNames.Count)"
if ($warnings.Count -gt 0) {
  Write-Host 'Warnings:'
  $warnings | ForEach-Object { Write-Host "- $_" }
}
Write-Host 'Kernel, canonical owners, prompt references, skill references, size guardrails, and validator paths are consistent.'
exit 0
