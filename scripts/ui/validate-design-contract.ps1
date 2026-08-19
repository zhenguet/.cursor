param(
  [Parameter(Mandatory = $true)]
  [string]$ContractPath,

  [Parameter(Mandatory = $true)]
  [string]$ObservedPath
)

$ErrorActionPreference = 'Stop'

function Fail($Message) {
  Write-Output "FAIL: $Message"
  exit 1
}

if (-not (Test-Path $ContractPath)) { Fail "Contract not found: $ContractPath" }
if (-not (Test-Path $ObservedPath)) { Fail "Observed evidence not found: $ObservedPath" }

$contract = Get-Content $ContractPath -Raw | ConvertFrom-Json
$observed = Get-Content $ObservedPath -Raw | ConvertFrom-Json
$failures = @()

if ([string]::IsNullOrWhiteSpace([string]$contract.version)) { $failures += 'Contract version is missing' }
if (-not $contract.viewport.width -or -not $contract.viewport.height) { $failures += 'Reference viewport is missing' }

$expectedElements = @($contract.elements)
$observedElements = @($observed.elements)

$expectedIds = @($expectedElements | ForEach-Object { [string]$_.id })
$observedIds = @($observedElements | ForEach-Object { [string]$_.id })

$missing = @($expectedIds | Where-Object { $_ -notin $observedIds })
$extra = @($observedIds | Where-Object { $_ -notin $expectedIds })

if ($missing.Count -gt 0) { $failures += "Missing elements: $($missing -join ', ')" }
if ($extra.Count -gt 0) { $failures += "Unexpected elements: $($extra -join ', ')" }
if (($expectedIds | Sort-Object -Unique).Count -ne $expectedIds.Count) { $failures += 'Contract contains duplicate element ids' }
if (($observedIds | Sort-Object -Unique).Count -ne $observedIds.Count) { $failures += 'Observed evidence contains duplicate element ids' }

foreach ($expected in $expectedElements) {
  $actual = @($observedElements | Where-Object { $_.id -eq $expected.id }) | Select-Object -First 1
  if (-not $actual) { continue }

  if ($null -ne $expected.type -and [string]$expected.type -ne [string]$actual.type) {
    $failures += "Element type mismatch for $($expected.id): expected [$($expected.type)], observed [$($actual.type)]"
  }

  if ($null -ne $expected.order -and $expected.order -ne $actual.order) {
    $failures += "Element order mismatch for $($expected.id): expected [$($expected.order)], observed [$($actual.order)]"
  }

  if ($null -ne $expected.parent -and [string]$expected.parent -ne [string]$actual.parent) {
    $failures += "Element parent mismatch for $($expected.id): expected [$($expected.parent)], observed [$($actual.parent)]"
  }

  foreach ($property in @('required', 'visible', 'row', 'column', 'columnSpan', 'rowSpan')) {
    if ($null -ne $expected.$property -and $null -eq $actual.$property) {
      $failures += "Missing evidence [$property] for element $($expected.id)"
    } elseif ($null -ne $expected.$property -and [string]$expected.$property -ne [string]$actual.$property) {
      $failures += "Element $($expected.id) [$property] mismatch: expected [$($expected.$property)], observed [$($actual.$property)]"
    }
  }
}

foreach ($container in @($contract.layout.containers)) {
  $observedContainer = @($observed.layout.containers | Where-Object { $_.id -eq $container.id }) | Select-Object -First 1
  if (-not $observedContainer) {
    $failures += "Missing layout container: $($container.id)"
    continue
  }

  if ([string]$container.display -ne [string]$observedContainer.display) {
    $failures += "Layout display mismatch for $($container.id): expected [$($container.display)], observed [$($observedContainer.display)]"
  }

  foreach ($property in @('columns', 'rows', 'expectedItemOrder')) {
    if ($null -eq $container.$property) { continue }
    if ($null -eq $observedContainer.$property) {
      $failures += "Missing [$property] evidence for layout container $($container.id)"
      continue
    }

    $expectedValue = @($container.$property | ForEach-Object { [string]$_ }) -join ' '
    $observedValue = @($observedContainer.$property | ForEach-Object { [string]$_ }) -join ' '
    if ($expectedValue -ne $observedValue) {
      $failures += "Layout [$property] mismatch for $($container.id): expected [$expectedValue], observed [$observedValue]"
    }
  }

  foreach ($group in @($container.sameRowGroups)) {
    $rows = @(
      foreach ($id in @($group)) {
        $item = @($observedElements | Where-Object { $_.id -eq $id }) | Select-Object -First 1
        if (-not $item) {
          $failures += "Missing observed element $id in same-row group [$($group -join ', ')]"
          continue
        }
        if ($null -eq $item.row) {
          $failures += "Missing row evidence for element $id in same-row group [$($group -join ', ')]"
          continue
        }
        [string]$item.row
      }
    ) | Sort-Object -Unique

    if ($rows.Count -gt 1) {
      $failures += "Same-row invariant violated: [$($group -join ', ')] spans rows [$($rows -join ', ')]"
    }
  }
}

if ($failures.Count -gt 0) {
  Write-Output 'UI Design Validation: FAIL'
  $failures | ForEach-Object { Write-Output "- $_" }
  exit 1
}

Write-Output 'UI Design Validation: PASS'
Write-Output "Elements: $($expectedElements.Count) expected / $($observedElements.Count) observed"
Write-Output "Reference viewport: $($contract.viewport.width)x$($contract.viewport.height)"
exit 0
