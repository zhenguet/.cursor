param(
  [Parameter(Mandatory = $true)]
  [string]$ContractPath,

  [Parameter(Mandatory = $true)]
  [string]$ObservedPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $ContractPath)) { Write-Output "FAIL: Contract not found: $ContractPath"; exit 1 }
if (-not (Test-Path $ObservedPath)) { Write-Output "FAIL: Observed evidence not found: $ObservedPath"; exit 1 }

$contract = Get-Content $ContractPath -Raw | ConvertFrom-Json
$observed = Get-Content $ObservedPath -Raw | ConvertFrom-Json
$failures = @()

$contractTransitions = @($contract.transitions)
$observedTransitions = @($observed.transitions)

foreach ($expected in $contractTransitions) {
  $matches = @($observedTransitions | Where-Object {
    $_.current -eq $expected.current -and $_.action -eq $expected.action
  })

  if ($matches.Count -eq 0) {
    $failures += "Missing transition evidence: $($expected.current) + $($expected.action)"
    continue
  }

  $actual = $matches | Select-Object -First 1

  if ([bool]$actual.allowed -ne [bool]$expected.allowed) {
    $failures += "Allowed mismatch: $($expected.current) + $($expected.action): expected $($expected.allowed), observed $($actual.allowed)"
  }

  if ($null -ne $expected.next -and [string]$actual.next -ne [string]$expected.next) {
    $failures += "Next-state mismatch: $($expected.current) + $($expected.action): expected $($expected.next), observed $($actual.next)"
  }
}

if ($failures.Count -gt 0) {
  Write-Output 'Backend State Validation: FAIL'
  $failures | ForEach-Object { Write-Output "- $_" }
  exit 1
}

Write-Output 'Backend State Validation: PASS'
Write-Output "Transitions checked: $($contractTransitions.Count)"
exit 0
