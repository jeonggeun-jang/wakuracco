# 서브셋 폰트 재생성 스크립트
#
# lib/ 소스 코드에 등장하는 글자만 추출해 폰트 용량을 줄인다 (6MB → ~600KB).
# 페이지에 새 텍스트(특히 새로운 한글/한자/가나 글자)를 추가했다면
# 이 스크립트를 다시 실행해서 assets/fonts/를 갱신해야 한다.
# 서브셋에 없는 글자는 Flutter 엔진이 폴백 폰트를 내려받아 표시하므로
# 깨지지는 않지만 모양이 살짝 달라질 수 있다.
#
# 필요: Python + fonttools (pip install fonttools)
# 사용: powershell -File tool\subset_fonts.ps1

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$work = Join-Path $env:TEMP 'waku-fonts'
New-Item -ItemType Directory -Force $work | Out-Null
New-Item -ItemType Directory -Force (Join-Path $projectRoot 'assets\fonts') | Out-Null

Write-Host '1/4 원본 폰트 다운로드 (google/fonts, OFL 라이선스)'
Invoke-WebRequest -Uri 'https://github.com/google/fonts/raw/main/ofl/jua/Jua-Regular.ttf' `
  -OutFile (Join-Path $work 'Jua-Regular.ttf')
Invoke-WebRequest -Uri 'https://github.com/google/fonts/raw/main/ofl/notosanskr/NotoSansKR%5Bwght%5D.ttf' `
  -OutFile (Join-Path $work 'NotoSansKR-VF.ttf')

Write-Host '2/4 가변 폰트에서 400/700 굵기 추출'
python -m fontTools.varLib.instancer --output (Join-Path $work 'NotoSansKR-w400.ttf') (Join-Path $work 'NotoSansKR-VF.ttf') wght=400
python -m fontTools.varLib.instancer --output (Join-Path $work 'NotoSansKR-w700.ttf') (Join-Path $work 'NotoSansKR-VF.ttf') wght=700

Write-Host '3/4 소스 코드에서 사용 글자 수집'
$files = Get-ChildItem (Join-Path $projectRoot 'lib') -Recurse -Filter *.dart
$text = ($files | ForEach-Object {
    [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
  }) -join "`n"
$ascii = -join (32..126 | ForEach-Object { [char]$_ })
$charsFile = Join-Path $work 'chars.txt'
[System.IO.File]::WriteAllText($charsFile, $text + $ascii, [System.Text.UTF8Encoding]::new($false))

Write-Host '4/4 서브셋 생성'
$out = Join-Path $projectRoot 'assets\fonts'
python -m fontTools.subset (Join-Path $work 'NotoSansKR-w400.ttf') --text-file=$charsFile --output-file=(Join-Path $out 'NotoSansKR-Regular.ttf')
python -m fontTools.subset (Join-Path $work 'NotoSansKR-w700.ttf') --text-file=$charsFile --output-file=(Join-Path $out 'NotoSansKR-Bold.ttf')
python -m fontTools.subset (Join-Path $work 'Jua-Regular.ttf') --text-file=$charsFile --output-file=(Join-Path $out 'Jua-Regular.ttf')

Get-ChildItem $out -Filter *.ttf | Select-Object Name, @{N = 'KB'; E = { [math]::Round($_.Length / 1KB) } }
Write-Host '완료! flutter run으로 확인 후 커밋하세요.'
