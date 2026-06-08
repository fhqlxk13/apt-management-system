param(
    [Parameter(Mandatory = $true)][string]$SnapshotPath,
    [Parameter(Mandatory = $true)][string]$OutputPath
)

$ErrorActionPreference = 'Stop'

function Escape-Xml {
    param([string]$Value)
    if ($null -eq $Value) { return '' }
    return $Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

function Rgba-To-Hex {
    param([string]$Rgba)
    if ($Rgba -match 'rgba\((\d+),\s*(\d+),\s*(\d+),') {
        return ('#{0:X2}{1:X2}{2:X2}' -f [int]$Matches[1], [int]$Matches[2], [int]$Matches[3])
    }
    return '#008866'
}

$snapshot = Get-Content -LiteralPath $SnapshotPath -Raw -Encoding UTF8 | ConvertFrom-Json
$entities = @($snapshot.entityData)

$minX = [int](($entities | ForEach-Object { $_.position.x } | Measure-Object -Minimum).Minimum) - 200
$minY = [int](($entities | ForEach-Object { $_.position.y } | Measure-Object -Minimum).Minimum) - 200
$maxX = [int](($entities | ForEach-Object { $_.position.x } | Measure-Object -Maximum).Maximum) + 650
$maxY = [int](($entities | ForEach-Object { $_.position.y } | Measure-Object -Maximum).Maximum) + 650
$width = $maxX - $minX
$height = $maxY - $minY

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("<svg xmlns='http://www.w3.org/2000/svg' width='$width' height='$height' viewBox='$minX $minY $width $height'>")
[void]$sb.AppendLine("<rect x='$minX' y='$minY' width='$width' height='$height' fill='#282828'/>")

foreach ($entity in $entities) {
    $x = [int]$entity.position.x
    $y = [int]$entity.position.y
    $columns = @($entity.keys.pks) + @($entity.keys.fks) + @($entity.fields)
    $tableHeight = [Math]::Max(70, 28 + ($columns.Count * 15))
    $tableWidth = 330
    $color = Rgba-To-Hex $entity.color

    [void]$sb.AppendLine("<g>")
    [void]$sb.AppendLine("<rect x='$x' y='$y' width='$tableWidth' height='$tableHeight' fill='#1d1d1d' stroke='$color' stroke-width='2'/>")
    [void]$sb.AppendLine("<rect x='$x' y='$y' width='$tableWidth' height='24' fill='$color'/>")
    [void]$sb.AppendLine("<text x='$($x + 8)' y='$($y + 17)' fill='white' font-family='Malgun Gothic, Arial' font-size='13' font-weight='700'>$(Escape-Xml $entity.name)  $(Escape-Xml $entity.pName)</text>")
    $textY = $y + 40
    foreach ($column in ($columns | Select-Object -First 28)) {
        $marker = ''
        if (@($entity.keys.pks).pName -contains $column.pName) {
            $marker = 'PK '
        } elseif (@($entity.keys.fks).pName -contains $column.pName) {
            $marker = 'FK '
        }
        [void]$sb.AppendLine("<text x='$($x + 8)' y='$textY' fill='#e8e8e8' font-family='Malgun Gothic, Consolas' font-size='10'>$marker$(Escape-Xml $column.name) : $(Escape-Xml $column.pName) $(Escape-Xml $column.type)</text>")
        $textY += 15
    }
    [void]$sb.AppendLine("</g>")
}

[void]$sb.AppendLine("</svg>")
[System.IO.File]::WriteAllText($OutputPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Get-Item -LiteralPath $OutputPath | Select-Object FullName, Length, LastWriteTime
