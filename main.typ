// Коммерческое предложение "Щёлково Агрохим"
// Typst шаблон

// Настройка документа
#set document(
  title: "Коммерческое предложение - Щёлково Агрохим",
  author: "АО Щёлково Агрохим",
)

#set page(
  paper: "a4",
  margin: (top: 1.3cm, bottom: 1.5cm, left: 2cm, right: 1.3cm),
)

#set text(
  font: "Roboto",
  size: 10pt,
  lang: "ru",
  fill: rgb("#125488"),
)

// Определение цветов
#let main-color = rgb("#125488")
#let company-color = rgb("#1D646A")
#let teal-color = rgb("#125488")
#let teal-dark = rgb("#125488")
#let magenta-color = rgb("#C71585")
#let light-teal = rgb("#E0F5F5")
#let header-bg = rgb("#007777")

// Цвета для чёрно-белой таблицы
#let table-header-bg = rgb("#EFEFEF")
#let table-alt-row = rgb("#FAFAFA")
#let table-border = rgb("#DFDFDF")

// Загрузка данных из JSON файла
#let data = json("data.json")
#let client-name = data.client_name
#let year = data.year
#let product-title = data.product_title
#let subtitle = data.subtitle
#let products = data.products

#let grand-total = products.map(p => p.total).sum()

// Функция форматирования чисел с разделителем тысяч
#let format-number(n) = {
  let s = str(n)
  let result = ""
  let count = 0
  for c in s.rev() {
    if count > 0 and calc.rem(count, 3) == 0 {
      result = " " + result
    }
    result = c + result
    count += 1
  }
  result
}

// ==================== СТРАНИЦА 1: ОБЛОЖКА ====================

// Верхняя часть обложки с годом и декоративными элементами
#block[
  #grid(
    columns: (1fr, 1fr),
    // Год слева
    align(left)[
      #text(size: 60pt, weight: "bold", fill: teal-color)[#year]
    ],
    // Декоративные элементы справа (плейсхолдер)
    align(right)[
      // Используйте для реального изображения:
      #image("decor-header.png", width: 280pt)
    ]
  )
]


// Используйте для реального изображения:
#image("logo.png", width: 220pt)


// Заголовок продукта
#text(size: 24pt, weight: "bold", fill: teal-dark)[#product-title]

// Подзаголовок
#text(size: 18pt, fill: teal-color, weight: 300)[#subtitle]

// Описание
#text(size: 10pt, weight: 400)[
  Мы уверены, что предлагаемая система позволит вам максимально \
  реализовать потенциал урожайности ваших полей.
]

#v(0.5cm)

// Секция с декоративным изображением и информацией о предложении
#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  // Декоративная композиция слева (плейсхолдер)
  align(left)[
    // Используйте для реального изображения:
    #image("decor-body.png", width: 320pt)
  ],
  // Информация справа
  align(right)[
    #v(0.5cm)
    #text(size: 14pt, weight: "bold")[Коммерческое] \
    #text(size: 14pt, weight: "bold")[предложение]
    #v(0.5cm)
    #text(size: 10pt)[Кому:] \
    #text(size: 12pt, weight: "bold")[#client-name]
  ]
)

#v(1cm)

// Фото (плейсхолдер)
#align(center)[
  // Используйте это для реального изображения:
  #image("team-photo.png", width: 100%)
]

// ==================== СТРАНИЦА 2: ТАБЛИЦА ====================

#pagebreak()

// Шапка страницы с логотипом и контактами
#block[
  #grid(
    columns: (auto, 1fr),
    gutter: 20pt,
    align: horizon,
    // Логотип слева (плейсхолдер)
    [
      #image("logo.png", height: 45pt)
    ],
    // Контакты справа
    align(right)[
      #set text(size: 7pt, fill: black)
      141108, Московская область, г. Щелково, ул. Заводская, д. 2 (Центральный офис) \
      Тел.: +7 (495) 777-84-89 | E-mail: info\@betaren.ru | Сайт: betaren.ru \
      ИНН 5050029646 | КПП 505001001 | ОГРН 1025006519427 | ОКПО 48811647
    ]
  )
]


\

// Получатель
#text(size: 10pt, weight: "bold", fill: black)[Кому: #client-name]

#v(0.2cm)

// Заголовок
#align(center)[
  #text(size: 24pt, weight: "bold", fill: company-color)[Коммерческое предложение]
]


// Таблица продуктов (чёрно-белая)
#set table(
  stroke: 0.5pt + black,
  inset: 7pt,
)

#let header-cell(content) = table.cell(
  fill: table-header-bg,
  text(fill: rgb("000000"), weight: "bold", size: 9pt)[#content]
)

#let alt-row(idx) = if calc.rem(idx, 2) == 0 { table-alt-row } else { white }

#table(
  columns: (0.5fr, 2fr, 2fr, 1fr, 0.7fr, 1.2fr, 1.2fr),
  align: (left + horizon, left + horizon, left + horizon, left + horizon, left + horizon, left + horizon, left + horizon),
  
  // Заголовок таблицы
  header-cell[№],
  header-cell[Наименование / \ Категория],
  header-cell[Форма препарата / \ Особенности],
  header-cell[Ед. изм.],
  header-cell[Кол-\ во],
  header-cell[Цена за ед. \ (ориент. \ руб.)],
  header-cell[Сумма \ (руб.)],
  
  // Данные таблицы
  ..for (idx, p) in products.enumerate() {
    let bg = alt-row(idx)
    (
      table.cell(fill: bg)[#text(fill: black)[#p.num]],
      table.cell(fill: bg)[#text(weight: "bold", fill: black)[#p.name]],
      table.cell(fill: bg)[#text(fill: black)[#p.form]],
      table.cell(fill: bg)[#text(fill: black)[#p.unit]],
      table.cell(fill: bg)[#text(fill: black)[#p.qty]],
      table.cell(fill: bg)[#text(fill: black)[#format-number(p.price)]],
      table.cell(fill: bg)[#text(fill: black)[#format-number(p.total)]],
    )
  },
  
  // Итого
  table.cell(colspan: 5, fill: white)[],
  table.cell(fill: white)[#align(right)[#text(weight: "bold", fill: black)[ИТОГО]]],
  table.cell(fill: white)[#align(right)[#text(weight: "bold", fill: black)[#format-number(grand-total)]]],
)

#v(0.8cm)

// Нижняя часть с подписью и печатью
#grid(
  columns: (1.5fr, 1fr),
  // Текст слева
  [
    #text(size: 9pt, fill: black)[
      Мы уверены, что предлагаемая система позволит вам максимально \
      реализовать потенциал урожайности ваших полей.
    ]
    
    #v(0.5cm)
    
    #text(size: 9pt, fill: black)[
      С уважением, \[Ваше Имя/Название компании\] \
      Официальный партнер АО «Щелково Агрохим»
    ]
  ],
  // Печать и подпись справа (плейсхолдер)
  align(right)[
    // Используйте это для реальных изображений:
    // #image("stamp.png", width: 159pt)
  ]
)
