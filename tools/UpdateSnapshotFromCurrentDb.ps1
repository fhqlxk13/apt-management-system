param(
    [Parameter(Mandatory = $true)][string]$SnapshotPath,
    [Parameter(Mandatory = $true)][string]$SchemaSqlPath,
    [Parameter(Mandatory = $true)][string]$OutputPath
)

$ErrorActionPreference = 'Stop'

function New-Id {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.ToCharArray()
    -join (1..17 | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
}

function Copy-Field {
    param(
        [object]$Source,
        [object]$Column,
        [bool]$IsFk,
        [hashtable]$ExistingByColumn
    )

    $base = $ExistingByColumn[$Column.Name]
    $id = if ($base) { $base._id } else { New-Id }
    $logicalName = if ($base -and $base.name) { $base.name } else { $Column.Name }
    $comment = if ($base -and $base.comment) { $base.comment } else { '' }
    $relType = if ($base -and $base.relType) { $base.relType } elseif ($IsFk) { 'ZERO_OR_MANY' } else { $null }
    $relGroupId = if ($base -and $base.relGroupId) { $base.relGroupId } elseif ($IsFk) { New-Id } else { $null }

    [pscustomobject]@{
        _id = $id
        name = $logicalName
        pName = $Column.Name
        domain = ''
        type = $Column.Type
        defaultValue = $Column.DefaultValue
        isAllowNull = [bool]$Column.AllowNull
        comment = $comment
        relEntity = $null
        relFieldId = $null
        relType = $relType
        relGroupId = $relGroupId
    }
}

function Get-EntityLogicalName {
    param([string]$TableName, [object]$BaseEntity)
    if ($BaseEntity -and $BaseEntity.name) { return $BaseEntity.name }
    $names = @{
        KAKAO_ALIM = "$([char]0xCE74)$([char]0xCE74)$([char]0xC624) $([char]0xC54C)$([char]0xB9BC)"
        NOTICE = "$([char]0xACF5)$([char]0xC9C0)"
        USER_ROLE = "$([char]0xC0AC)$([char]0xC6A9)$([char]0xC790) $([char]0xAD8C)$([char]0xD55C)"
    }
    if ($names.ContainsKey($TableName)) { return $names[$TableName] }
    return $TableName
}

function Get-EntityColor {
    param([string]$TableName, [object]$BaseEntity)
    if ($BaseEntity -and $BaseEntity.color) { return $BaseEntity.color }
    if ($TableName -match 'PAY|BILL|REFUND|WEBHOOK|AUTO') { return 'rgba(0, 106, 178, 0.5)' }
    if ($TableName -match 'BOARD|POST|COMMENT|ANN|NOTICE') { return 'rgba(10, 10, 10, 0.5)' }
    if ($TableName -match 'MGMT|MNGR|MANAGER|ADM|USER_ROLE|AUTH') { return 'rgba(178, 69, 0, 0.5)' }
    if ($TableName -match 'MEMBER|HSHLD|RESIDENT|RSID|VST|CVPL') { return 'rgba(123, 0, 178, 0.5)' }
    if ($TableName -match 'APT|RENT|BUDGET|EXPENSE|COMPLEX') { return 'rgba(177, 178, 0, 0.5)' }
    return 'rgba(0, 178, 100, 0.5)'
}

function Get-NewPosition {
    param([string]$TableName, [hashtable]$EntityByName)

    $positions = @{
        KAKAO_ALIM = @{ x = 3550; y = 4860 }
        NOTICE = @{ x = 5100; y = 4930 }
        USER_ROLE = @{ x = 4100; y = 2860 }
    }
    if ($positions.ContainsKey($TableName)) {
        return [pscustomobject]$positions[$TableName]
    }

    $anchorName = if ($TableName -match 'BOARD|POST|COMMENT|ANN') {
        'CENTER_BOARD_INSTANCE'
    } elseif ($TableName -match 'PAY|BILL|REFUND') {
        'PAYMENT'
    } elseif ($TableName -match 'MGMT|MNGR|MANAGER|ADM') {
        'MANAGER'
    } elseif ($TableName -match 'MEMBER|AUTH|USER_ROLE') {
        'MEMBER'
    } elseif ($TableName -match 'CHAT') {
        'CHAT_ROOM'
    } else {
        'APT_COMPLEX'
    }

    $anchor = $EntityByName[$anchorName]
    if ($anchor) {
        return [pscustomobject]@{ x = [int]$anchor.position.x + 360; y = [int]$anchor.position.y + 120 }
    }
    return [pscustomobject]@{ x = 6500; y = 5200 }
}

function Parse-Schema {
    param([string]$Sql)

    $tables = [ordered]@{}
    $tableRegex = [regex]'(?s)CREATE TABLE "([^"]+)" \(\s*(.*?)\s*\);'
    foreach ($m in $tableRegex.Matches($Sql)) {
        $tableName = $m.Groups[1].Value
        $columns = New-Object System.Collections.ArrayList
        $lines = $m.Groups[2].Value -split "`r?`n"
        foreach ($rawLine in $lines) {
            $line = $rawLine.Trim().TrimEnd(',')
            if ($line -notmatch '^"([^"]+)"\s+(.+?)\s+(NOT NULL|NULL)$') { continue }
            $colName = $Matches[1]
            $typeAndDefault = $Matches[2].Trim()
            $nullableText = $Matches[3]
            $type = $typeAndDefault
            $default = ''
            if ($typeAndDefault -match '^(.*?)\s+DEFAULT\s+(.+)$') {
                $type = $Matches[1].Trim()
                $default = $Matches[2].Trim()
            }
            [void]$columns.Add([pscustomobject]@{
                Name = $colName
                Type = $type
                DefaultValue = $default
                AllowNull = ($nullableText -eq 'NULL')
            })
        }
        $tables[$tableName] = [pscustomobject]@{
            Name = $tableName
            Columns = $columns
            Pks = @()
            Fks = @()
        }
    }

    $pkRegex = [regex]'ALTER TABLE "([^"]+)" ADD CONSTRAINT "([^"]+)" PRIMARY KEY \(([^)]+)\);'
    foreach ($m in $pkRegex.Matches($Sql)) {
        $tableName = $m.Groups[1].Value
        if (-not $tables.Contains($tableName)) { continue }
        $tables[$tableName].Pks = @($m.Groups[3].Value -split ',' | ForEach-Object { $_.Trim().Trim('"') })
    }

    $fkRegex = [regex]'(?s)ALTER TABLE "([^"]+)" ADD CONSTRAINT "([^"]+)" FOREIGN KEY \(([^)]+)\)\s+REFERENCES "([^"]+)" \(([^)]+)\)'
    foreach ($m in $fkRegex.Matches($Sql)) {
        $tableName = $m.Groups[1].Value
        if (-not $tables.Contains($tableName)) { continue }
        $tables[$tableName].Fks += [pscustomobject]@{
            Name = $m.Groups[2].Value
            Columns = @($m.Groups[3].Value -split ',' | ForEach-Object { $_.Trim().Trim('"') })
            RefTable = $m.Groups[4].Value
            RefColumns = @($m.Groups[5].Value -split ',' | ForEach-Object { $_.Trim().Trim('"') })
        }
    }

    return $tables
}

$snapshot = Get-Content -LiteralPath $SnapshotPath -Raw -Encoding UTF8 | ConvertFrom-Json
$schemaSql = Get-Content -LiteralPath $SchemaSqlPath -Raw -Encoding UTF8
$tables = Parse-Schema $schemaSql

$aliases = @{
    ADM = 'ADMINISTRATOR'
    CHAT_ROOM_READ = 'MESSAGE_READ'
}

$oldByName = @{}
foreach ($entity in $snapshot.entityData) {
    $oldByName[$entity.pName] = $entity
}

$newEntities = New-Object System.Collections.ArrayList
$newByName = @{}
$usedIds = @{}

foreach ($tableName in $tables.Keys) {
    $baseName = if ($oldByName.ContainsKey($tableName)) { $tableName } elseif ($aliases.ContainsKey($tableName)) { $aliases[$tableName] } else { $null }
    $base = if ($baseName) { $oldByName[$baseName] } else { $null }

    $existingFields = @{}
    if ($base) {
        foreach ($section in @($base.fields, $base.keys.pks, $base.keys.fks)) {
            foreach ($field in @($section)) {
                if ($field -and $field.pName) { $existingFields[$field.pName] = $field }
            }
        }
    }

    $position = if ($base) { $base.position } else { Get-NewPosition $tableName $oldByName }
    $entity = [pscustomobject]@{
        _id = if ($base) { $base._id } else { New-Id }
        _diagramId = if ($base) { $base._diagramId } else { $snapshot.entityData[0]._diagramId }
        position = [pscustomobject]@{ x = [int]$position.x; y = [int]$position.y }
        name = Get-EntityLogicalName $tableName $base
        pName = $tableName
        fields = @()
        keys = [pscustomobject]@{ pks = @(); fks = @() }
        color = Get-EntityColor $tableName $base
    }

    $fkColumns = @{}
    foreach ($fk in $tables[$tableName].Fks) {
        foreach ($col in $fk.Columns) { $fkColumns[$col] = $true }
    }
    $pkColumns = @{}
    foreach ($col in $tables[$tableName].Pks) { $pkColumns[$col] = $true }

    $normalFields = New-Object System.Collections.ArrayList
    $pkFields = New-Object System.Collections.ArrayList
    $fkFields = New-Object System.Collections.ArrayList

    foreach ($column in $tables[$tableName].Columns) {
        $isFk = $fkColumns.ContainsKey($column.Name)
        $field = Copy-Field -Column $column -IsFk $isFk -ExistingByColumn $existingFields
        if ($isFk) {
            [void]$fkFields.Add($field)
        } elseif ($pkColumns.ContainsKey($column.Name)) {
            [void]$pkFields.Add($field)
        } else {
            [void]$normalFields.Add($field)
        }
    }

    $entity.fields = @($normalFields)
    $entity.keys.pks = @($pkFields)
    $entity.keys.fks = @($fkFields)

    [void]$newEntities.Add($entity)
    $newByName[$tableName] = $entity
    $usedIds[$entity._id] = $true
}

$fieldByTableAndColumn = @{}
foreach ($entity in $newEntities) {
    $fieldMap = @{}
    foreach ($field in @($entity.fields) + @($entity.keys.pks) + @($entity.keys.fks)) {
        if ($field -and $field.pName) { $fieldMap[$field.pName] = $field }
    }
    $fieldByTableAndColumn[$entity.pName] = $fieldMap
}

foreach ($tableName in $tables.Keys) {
    $entity = $newByName[$tableName]
    foreach ($fk in $tables[$tableName].Fks) {
        if (-not $newByName.ContainsKey($fk.RefTable)) { continue }
        $targetEntity = $newByName[$fk.RefTable]
        for ($i = 0; $i -lt $fk.Columns.Count; $i++) {
            $sourceCol = $fk.Columns[$i]
            $targetCol = if ($i -lt $fk.RefColumns.Count) { $fk.RefColumns[$i] } else { $fk.RefColumns[0] }
            $sourceField = $fieldByTableAndColumn[$tableName][$sourceCol]
            $targetField = $fieldByTableAndColumn[$fk.RefTable][$targetCol]
            if ($sourceField -and $targetField) {
                $sourceField.relEntity = $targetEntity._id
                $sourceField.relFieldId = $targetField._id
                if (-not $sourceField.relType) { $sourceField.relType = 'ZERO_OR_MANY' }
                if (-not $sourceField.relGroupId) { $sourceField.relGroupId = New-Id }
            }
        }
    }
}

$snapshot.entityData = @($newEntities)
$snapshot.createdAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffK')

$json = $snapshot | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($OutputPath, $json, [System.Text.UTF8Encoding]::new($false))

$oldNames = @($oldByName.Keys | Sort-Object)
$newNames = @($tables.Keys | Sort-Object)
$added = @($newNames | Where-Object { $_ -notin $oldNames -and (-not $aliases.ContainsKey($_)) })
$removed = @($oldNames | Where-Object { $_ -notin $newNames -and ($_ -notin $aliases.Values) })

Write-Host "Updated snapshot: $OutputPath"
Write-Host "Tables: $($newNames.Count)"
Write-Host "Added physical tables: $($added -join ', ')"
Write-Host "Removed old physical tables: $($removed -join ', ')"
