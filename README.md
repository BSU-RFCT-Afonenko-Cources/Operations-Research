# Установка

## Программы

1.  [Julia](https://julialang.org/downloads/)
2.  [Python](https://www.python.org/downloads/)
3.  [R](https://cloud.r-project.org/)
4.  [Quarto CLI](https://quarto.org/docs/get-started/)
5.  [RStudio](https://posit.co/download/rstudio-desktop/), Quarto входит в состав RStudio
6.  [Asymptote](https://asymptote.sourceforge.io/doc/Installation.html)
7.  [TeXLive](https://www.tug.org/texlive/)
8.  Сhromium совместимый браузер
9.  [MiniZinc](https://www.minizinc.org/downloads/)
10. [GraphViz](https://graphviz.org/download/)

### Windows

Дополнительно установить

1.  [Ghostscript](https://www.ghostscript.com/releases/gsdnld.html)
2.  [Sumatra PDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer)
3.  [rsvg-convert](https://sourceforge.net/projects/tumagcc/files/converters/rsvg-convert.exe/download) Перенести в каталог (например `С:\LibExe`) и добавить его в `PATH`.

Существует проблема `rsvg` не находит шрифты windows, текст на svg картинках не отображается.

### Linux

Дополнительно установить зависимости библиотек R для соответствующего дистрибутива

#### Arch

Для библиотеки R `leaflet` (виджеты географических карт).

1.  [gdal](https://archlinux.org/packages/extra/x86_64/gdal/)
2.  [libunits](https://aur.archlinux.org/packages/udunits)
3.  [netcdf](https://archlinux.org/packages/extra/x86_64/netcdf/)

## Переменные среды

### Windows

Если используется браузер отличный от [Google Chrome](https://www.google.com/intl/ru/chrome/), то установить следующие переменные. Например для [Microsoft Edge](https://www.microsoft.com/ru-ru/edge):

``` bash
CHROMOTE_CHROME="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
QUARTO_CHROMIUM="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
```

Вместо `<user>` подставить имя пользователя

``` bash
ASYMPTOTE_PDFVIEWER="C:\Users\<user>\AppData\Local\SumatraPDF\SumatraPDF.exe"
```

### Linux

## Пакеты Julia, Python, R

### R и Pyhton

При первом запуске в корне проекта вызвать R интерактивно и согласиться с установкой пакетов.

``` bash
R
```

Или запустить R в скриптовом режиме, тогда пакеты для r и python будут установлены автоматически.

``` bash
Rscript -e '1'
```

### Julia

``` bash
julia --project=.
```

``` julia
]
instantiate
```

## Проверка

Убедиться, что в переменной `PATH` присутствуют все программы. Если используется RStudio, то выполнить команды в терминале, открытом в RStudio

``` bash
quarto --version
r --version
julia --version
python --version
asy --version
xelatex --version
dot --version
```

### Windows

``` bash
gswin64 --version
```

# Конфигурации

## Полный сброс

``` bash
git clean -fxd
```

``` r
renv::rebuild()
```

## Частичный сброс

``` bash
./qclear.sh
```

Файлы использующие widgetframe обязаны отключать `cache` и `freeze` иначе файлы виджетов не копируются в итоговый каталог.

## Обновить пакеты

### R

``` r
renv::update()
```

### Python

``` bash
pip --disable-pip-version-check list --outdated --format=json |\
python -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" |\
xargs -n1 pip install -U
```

### Julia

``` bash
julia --project=.
```

``` julia
]
update
```

## Методичка

### pdf

``` bash
quarto render --to pdf --profile student,dev,pdf
```

### html

``` bash
quarto render --to html --profile student,dev,html
```

## Методичка с решениями

### pdf

``` bash
quarto render --to pdf --profile full,dev,pdf
```

### html

``` bash
quarto render --to html --profile full,dev,html
```

## Практические работы

### pdf

``` bash
quarto render --to pdf --profile dev,practice,pdf-class
```

### html

``` bash
quarto render --to html --profile dev,practice,html
```

### LaTeX

``` bash
quarto render --to latex --profile dev,practice,pdf-class
```

## Проверочные работы

### pdf

``` bash
quarto render --to pdf --profile dev,exam,pdf-class
```

### html

``` bash
quarto render --to html --profile dev,exam,html
```

### LaTeX

``` bash
quarto render --to latex --profile dev,exam,pdf-class
```

## Публикация

``` bash
clear && git clean -fdx && Rscript -e 1 && quarto publish gh-pages --profile student,prod,html
```

## Подсчёт строк кода

``` bash
cloc --vcs=git\
 --read-lang-def=cloc-qmd-lang-def\
 --exclude-ext=json,svg,toml,csv,graphml,csl\
 --exclude-dir=renv\
 --exclude-list-file=requirements.txt
```
