// Коммерческое предложение "Щёлково Агрохим" — ТОЛЬКО СЕМЕНА (без агрохимии)
// Обложка + карточка сорта + сводная таблица с ценой семян

// ============================================================
// Загрузка данных
// ============================================================
#let data = json("data.json")

#let client-name = data.client_name
#let region = data.region
#let manager-name = data.at("manager_name", default: "")
#let email = data.at("email", default: "")
#let phone = data.at("phone", default: "")
#let tech = data.technology
#let entries = data.entries
#let total-area = data.total_area
#let total-cost = data.total_cost

// ============================================================
// Настройка документа
// ============================================================
#set document(
  title: "КП Семена — " + client-name,
  author: "АО Щёлково Агрохим",
)

#set page(
  paper: "a4",
  margin: (top: 1.3cm, bottom: 1.5cm, left: 1.2cm, right: 1.1cm),
)

#set text(
  font: "Montserrat",
  size: 10pt,
  lang: "ru",
  fill: rgb("#1f1f1f"),
)

// ============================================================
// Цвета
// ============================================================
#let blue = rgb("#125488")
#let teal = rgb("#1E646A")
#let black = rgb("#1f1f1f")
#let header-bg = rgb("#EFEFEF")
#let alt-row = rgb("#FAFAFA")
#let white-stroke = white

// ============================================================
// Утилиты
// ============================================================

#let fmt(n) = {
  let val = calc.round(float(n), digits: 0)
  let s = str(val)
  if s.ends-with(".0") { s = s.slice(0, s.len() - 2) }
  let result = ""
  let count = 0
  for c in s.rev() {
    if count > 0 and calc.rem(count, 3) == 0 and c != "-" {
      result = " " + result
    }
    result = c + result
    count += 1
  }
  result
}

#let fmt-dec(n, digits: 1) = {
  if n == none { return "—" }
  let val = calc.round(float(n), digits: digits)
  str(val)
}

#let page-header() = {
  grid(
    columns: (auto, 1fr),
    gutter: 16pt,
    align: horizon,
    image("logo-small.png", height: 40pt),
    align(right)[
      #set text(size: 8pt, fill: rgb("#000000"))
      141108, Московская область, г. Щёлково, ул. Заводская, д. 2 (Центральный офис) \
      Тел.: +7 (495) 777-84-89 | E-mail: info\@betaren.ru | Сайт: betaren.ru \
      ИНН 5050029646 | КПП 505001001 | ОГРН 1025006519427 | ОКПО 48811647
    ],
  )
  v(0.4cm)
  line(length: 100%, stroke: 0.5pt + rgb("#DDDDDD"))
}

// ============================================================
// СТРАНИЦА 1: ОБЛОЖКА
// ============================================================

#grid(
  columns: (auto, 1fr),
  align: bottom,
  text(size: 50pt, weight: "bold", fill: blue, font: "Montserrat")[2026],
  align(right)[#image("decor-header.png", width: 230pt)],
)

#v(0.3cm)

// Логотип
#image("logo.png", width: 200pt)

#v(0.4cm)

// Заголовок
#text(size: 28pt, weight: "bold", fill: blue)[ОЗИМАЯ ПШЕНИЦА]

#v(0.15cm)

// Подзаголовок
#text(size: 20pt, fill: blue)[#tech.title]

#v(0.2cm)

// Описание
#text(size: 11pt, fill: blue)[
  Предлагаем элитные семена озимой пшеницы селекции
  АО «Щёлково Агрохим» для максимизации урожайности ваших полей.
]

#v(0.4cm)

// Декор + КП
#grid(
  columns: (1.3fr, 1fr),
  gutter: 0.5cm,
  image("decor-body.png", width: 100%),
  align(right + horizon)[
    #text(size: 12pt, fill: blue)[Кому:]
    #v(0.1cm)
    #text(size: 12pt, weight: "bold", fill: blue)[#client-name]
    #v(0.3cm)
    #text(size: 10pt, fill: blue)[#region]
    #v(0.5cm)
    #text(size: 12pt, weight: "bold", fill: blue)[Коммерческое]
    #linebreak()
    #text(size: 12pt, weight: "bold", fill: blue)[предложение]
  ],
)

#v(0.3cm)

#block(clip: true)[
  #image("team-photo.png", width: 100%, height: 35%)
]


// ============================================================
// ДЛЯ КАЖДОГО СОРТА: КАРТОЧКА
// ============================================================

#for (entry-idx, entry) in entries.enumerate() {

  let variety = entry.variety
  let area-ha = entry.area_ha
  let pain-label = entry.pain_label
  let pain-argument = entry.pain_argument
  let seeds = entry.calculation.seeds
  let seeds-cost = seeds.cost

  // ── СТРАНИЦА: РЕКОМЕНДОВАННЫЙ СОРТ ──
  pagebreak()
  page-header()
  v(0.3cm)

  // Кому
  text(size: 10pt, weight: "bold")[Кому: #client-name]
  h(1fr)
  text(size: 10pt, fill: rgb("#888888"))[#fmt(area-ha) га]

  v(0.5cm)

  // Заголовок сорта
  align(center)[
    #text(size: 25pt, weight: "bold", fill: teal)[#variety.name]
  ]

  v(0.4cm)

  // Карточка сорта
  block(
    width: 100%,
    fill: rgb("#F7F9FA"),
    radius: 4pt,
    inset: 14pt,
    stroke: 0.5pt + rgb("#E8ECEF"),
  )[
    #grid(
      columns: (1fr, auto),
      align: horizon,
      text(size: 14pt, weight: "bold", fill: blue)[#variety.name],
      text(size: 10pt, fill: teal, weight: "bold")[#variety.quality_class],
    )

    #v(0.2cm)
    #text(size: 9pt, fill: rgb("#666666"))[#variety.biotype]
    #v(0.4cm)

    // Урожайность
    #grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 10pt,
      block(fill: white, radius: 3pt, inset: 10pt, width: 100%, stroke: 0.5pt + rgb("#EEEEEE"))[
        #text(size: 7.5pt, fill: rgb("#999999"))[СРЕДНЯЯ УРОЖАЙНОСТЬ]
        #v(0.15cm)
        #text(size: 22pt, weight: "bold", fill: blue)[#if variety.yield_avg != none [#fmt-dec(variety.yield_avg)]]
        #text(size: 9pt, fill: rgb("#666666"))[ ц/га]
      ],
      block(fill: white, radius: 3pt, inset: 10pt, width: 100%, stroke: 0.5pt + rgb("#EEEEEE"))[
        #text(size: 7.5pt, fill: rgb("#999999"))[МАКСИМАЛЬНАЯ]
        #v(0.15cm)
        #text(size: 22pt, weight: "bold", fill: teal)[#if variety.yield_max != none [#fmt-dec(variety.yield_max)]]
        #text(size: 9pt, fill: rgb("#666666"))[ ц/га]
      ],
      block(fill: white, radius: 3pt, inset: 10pt, width: 100%, stroke: 0.5pt + rgb("#EEEEEE"))[
        #text(size: 7.5pt, fill: rgb("#999999"))[ПРОИЗВОДСТВЕННАЯ]
        #v(0.15cm)
        #text(size: 22pt, weight: "bold", fill: blue)[
          #if variety.yield_production != none [#fmt-dec(variety.yield_production)]
          #if variety.yield_production == none [—]
        ]
        #text(size: 9pt, fill: rgb("#666666"))[ ц/га]
      ],
    )

    #v(0.4cm)

    #if variety.protein_percent != none [
      #text(size: 9pt)[Протеин: *#fmt-dec(variety.protein_percent)%*]
      #h(1cm)
    ]
    #if variety.gluten_percent != none [
      #text(size: 9pt)[Клейковина: *#fmt-dec(variety.gluten_percent)%*]
    ]

    #v(0.3cm)

    #text(size: 10pt, weight: "bold", fill: teal)[Ключевые преимущества:]
    #v(0.1cm)
    #for adv in variety.key_advantages {
      text(size: 9pt)[• ] + text(size: 9pt, adv) + linebreak()
    }

    #v(0.2cm)
    #text(size: 8pt, fill: rgb("#999999"))[
      Госреестр с #variety.registry_since г. | Регионы: #variety.region_names.join(", ")
    ]
  ]

  v(0.4cm)

  // Блок фокуса
  block(
    width: 100%,
    fill: rgb("#F0F7F7"),
    radius: 4pt,
    inset: 14pt,
    stroke: 0.5pt + rgb("#D0E8E8"),
  )[
    #text(size: 11pt, weight: "bold", fill: teal)[Фокус: #pain-label]
    #v(0.15cm)
    #text(size: 9.5pt, fill: black)[#pain-argument]
  ]

  v(0.5cm)

  // Блок стоимости семян
  block(
    width: 100%,
    fill: rgb("#FFF8E8"),
    radius: 4pt,
    inset: 14pt,
    stroke: 0.5pt + rgb("#E8DDB0"),
  )[
    #text(size: 11pt, weight: "bold", fill: rgb("#8B6914"))[Стоимость семян]
    #v(0.2cm)
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      text(size: 9pt)[Сорт: *#seeds.variety*],
      text(size: 9pt)[Норма высева: *#tech.seeding_rate кг/га*],
      text(size: 9pt)[Объём: *#fmt-dec(seeds.volume_tonnes, digits: 1) т*],
      text(size: 9pt)[Цена: *#fmt(seeds.price_per_tonne) руб/т*],
    )
    #v(0.2cm)
    #line(length: 100%, stroke: 0.5pt + rgb("#E8DDB0"))
    #v(0.15cm)
    #text(size: 14pt, weight: "bold", fill: rgb("#8B6914"))[#fmt(seeds-cost) руб.]
    #h(0.5cm)
    #text(size: 10pt, fill: rgb("#8B6914"))[
      (#fmt(calc.round(seeds-cost / area-ha, digits: 0)) руб/га)
    ]
  ]
}


// ============================================================
// ФИНАЛЬНАЯ СТРАНИЦА: СВОДКА + ПОДПИСЬ
// ============================================================
#pagebreak()
#page-header()
#v(0.5cm)

#align(center)[
  #text(size: 25pt, weight: "bold", fill: teal)[Коммерческое предложение]
]

#v(0.3cm)
#text(size: 10pt, weight: "bold")[Кому: #client-name]
#v(0.5cm)

// Сводная таблица — только семена
#set table(
  stroke: 0.5pt + white-stroke,
  inset: 7pt,
)

#let shcell(content) = table.cell(
  fill: header-bg,
  text(fill: black, weight: "bold", size: 10pt)[#content],
)

#table(
  columns: (0.35fr, 2fr, 1fr, 1fr, 1.5fr, 1.2fr),
  align: (center + horizon, left + horizon, center + horizon, right + horizon, right + horizon, right + horizon),

  shcell[№],
  shcell[Сорт],
  shcell[Площадь (га)],
  shcell[Семена (т)],
  shcell[Стоимость семян (руб.)],
  shcell[Руб./га],

  ..for (idx, entry) in entries.enumerate() {
    let bg = if calc.rem(idx, 2) == 0 { white } else { alt-row }
    let seeds = entry.calculation.seeds
    let cost-ha = calc.round(seeds.cost / entry.area_ha, digits: 0)
    (
      table.cell(fill: bg)[#str(idx + 1)],
      table.cell(fill: bg)[#text(weight: "bold")[#entry.variety.name]],
      table.cell(fill: bg)[#fmt(entry.area_ha)],
      table.cell(fill: bg)[#fmt-dec(seeds.volume_tonnes, digits: 1)],
      table.cell(fill: bg)[#fmt(seeds.cost)],
      table.cell(fill: bg)[#fmt(cost-ha)],
    )
  },

  // Итого
  table.cell(colspan: 2, fill: white)[],
  table.cell(colspan: 2, fill: white)[
    #align(right)[#text(size: 12pt)[ИТОГО]]
  ],
  table.cell(fill: white)[
    #align(right)[#text(weight: "bold", size: 10pt)[#fmt(total-cost)]]
  ],
  table.cell(fill: white)[
    #let avg-cost = calc.round(total-cost / total-area, digits: 0)
    #align(right)[#text(weight: "bold")[#fmt(avg-cost)]]
  ],
)

#v(1cm)

#text(size: 10pt)[
  Мы уверены, что предлагаемая система позволит вам максимально
  реализовать потенциал урожайности ваших полей.
]

#v(0.5cm)

#grid(
  columns: (1.5fr, 1fr),
  [
    #text(size: 10pt)[
      С уважением,
    ]
    #if manager-name != "" [
      #text(size: 10pt)[#manager-name] \
    ]
    #text(size: 10pt)[Официальный партнёр АО «Щёлково Агрохим»]

    #v(0.5cm)

    #if email != "" [
      #text(size: 9pt, fill: rgb("#666666"))[E-mail: #email] \
    ]
    #if phone != "" [
      #text(size: 9pt, fill: rgb("#666666"))[Тел.: #phone]
    ]
  ],
  align(right)[
    #image("stamp.png", width: 140pt)
  ],
)
