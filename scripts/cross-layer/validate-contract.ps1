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

function Compare-Message($Name, $Expected, $Actual) {
  $localFailures = @()
  if (-not $Actual) {
    return @("Missing observed $Name message")
  }

  $expectedFields = @($Expected.fields)
  $actualFields = @($Actual.fields)
  $expectedNames = @($expectedFields | ForEach-Object { [string]$_.name })
  $actualNames = @($actualFields | ForEach-Object { [string]$_.name })

  @($expectedNames | Where-Object { $_ -notin $actualNames }) | ForEach-Object {
    $localFailures += "Missing $Name field: $_"
  }
  @($actualNames | Where-Object { $_ -notin $expectedNames }) | ForEach-Object {
    $localFailures += "Unexpected $Name field: $_"
  }

  foreach ($expectedField in $expectedFields) {
    $actualField = @($actualFields | Where-Object { $_.name -eq $expectedField.name }) | Select-Object -First 1
    if (-not $actualField) { continue }

    foreach ($property in @('type', 'nullable', 'required')) {
      if ([string]$expectedField.$property -ne [string]$actualField.$property) {
        $localFailures += "$Name field [$($expectedField.name)] $property mismatch: expected [$($expectedField.$property)], observed [$($actualField.$property)]"
      }
    }

    if ($null -ne $expectedField.enum) {
      $expectedEnum = @($expectedField.enum | ForEach-Object { [string]$_ }) -join '|'
      $actualEnum = @($actualField.enum | ForEach-Object { [string]$_ }) -join '|'
      if ($expectedEnum -ne $actualEnum) {
        $localFailures += "$Name field [$($expectedField.name)] enum mismatch: expected [$expectedEnum], observed [$actualEnum]"
      }
    }
  }

  return $localFailures
}

$failures += Compare-Message 'request' $contract.request $observed.request
$failures += Compare-Message 'response' $contract.response $observed.response

if ($null -ne $contract.operation.method -and [string]$contract.operation.method -ne [string]$observed.operation.method) {
  $failures += "Operation method mismatch: expected [$($contract.operation.method)], observed [$($observed.operation.method)]"
}

if ($null -ne $contract.operation.route -and [string]$contract.operation.route -ne [string]$observed.operation.route) {
  $failures += "Operation route mismatch: expected [$($contract.operation.route)], observed [$($observed.operation.route)]"
}

if ($null -ne $contract.authorization.required -and [string]$contract.authorization.required -ne [string]$observed.authorization.required) {
  $failures += "Authorization requirement mismatch: expected [$($contract.authorization.required)], observed [$($observed.authorization.required)]"
}

if ($null -ne $contract.stateTransition -and $null -ne $observed.stateTransition) {
  foreach ($property in @('current', 'action', 'next')) {
    if ($null -ne $contract.stateTransition.$property -and [string]$contract.stateTransition.$property -ne [string]$observed.stateTransition.$property) {
      $failures += "State transition [$property] mismatch: expected [$($contract.stateTransition.$property)], observed [$($observed.stateTransition.$property)]"
    }
  }
}

$expectedErrors = @($contract.errors)
$observedErrors = @($observed.errors)
$expectedErrorCodes = @($expectedErrors | ForEach-Object { [string]$_.code })
$observedErrorCodes = @($observedErrors | ForEach-Object { [string]$_.code })

@($expectedErrorCodes | Where-Object { $_ -notin $observedErrorCodes }) | ForEach-Object {
  $failures += "Missing error contract: $_"
}

foreach ($expectedError in $expectedErrors) {
  $actualError = @($observedErrors | Where-Object { $_.code -eq $expectedError.code }) | Select-Object -First 1
  if (-not $actualError) { continue }

  foreach ($property in @('httpStatus', 'retryable')) {
    if ($null -ne $expectedError.$property -and [string]$expectedError.$property -ne [string]$actualError.$property) {
      $failures += "Error [$($expectedError.code)] $property mismatch: expected [$($expectedError.$property)], observed [$($actualError.$property)]"
    }
  }
}

if ($failures.Count -gt 0) {
  Write-Output 'Cross-Layer Contract Validation: FAIL'
  $failures | ForEach-Object { Write-Output "- $_" }
  exit 1
}

Write-Output 'Cross-Layer Contract Validation: PASS'
Write-Output "Request fields: $(@($contract.request.fields).Count)"
Write-Output "Response fields: $(@($contract.response.fields).Count)"
Write-Output "Errors: $($expectedErrors.Count)"
exit 0
