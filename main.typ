// Коммерческое предложение "Щёлково Агрохим" — Озимая пшеница
// Typst шаблон — мульти-сортовое КП из data.json

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
  title: "Коммерческое предложение — " + client-name,
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
  fill: rgb("#333333"),
)

// ============================================================
// Цвета
// ============================================================
#let accent = rgb("#125488")
#let teal = rgb("#1D646A")
#let light-bg = rgb("#F4F8F9")
#let table-header-bg = rgb("#1D646A")
#let table-header-fg = white
#let table-alt-row = rgb("#F5F8FA")
#let table-border-color = rgb("#D0D8DD")
#let season-bg = rgb("#E8F0F2")
#let highlight-yellow = rgb("#FFF9E6")

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

// Шапка страницы (переиспользуемая)
#let page-header() = block[
  #grid(
    columns: (auto, 1fr),
    gutter: 20pt,
    align: horizon,
    [#image("logo.png", height: 45pt)],
    align(right)[
      #set text(size: 7pt, fill: rgb("#555555"))
      141108, Московская область, г. Щёлково, ул. Заводская, д. 2 \
      Тел.: +7 (495) 777-84-89 | E-mail: info\@betaren.ru | betaren.ru \
      ИНН 5050029646 | КПП 505001001 | ОГРН 1025006519427
    ],
  )
]

// ============================================================
// СТРАНИЦА 1: ОБЛОЖКА
// ============================================================

#block[
  #grid(
    columns: (1fr, 1fr),
    align(left)[
      #text(size: 54pt, weight: "bold", fill: accent)[2026]
    ],
    align(right)[
      #image("decor-header.png", width: 280pt)
    ],
  )
]

#image("logo.png", width: 220pt)

#text(size: 24pt, weight: "bold", fill: accent)[ОЗИМАЯ ПШЕНИЦА]

#v(0.2cm)

#text(size: 14pt, fill: accent, weight: 300)[#tech.title]

#v(0.2cm)

#text(size: 10pt)[
  Мы уверены, что предлагаемая система позволит вам максимально \
  реализовать потенциал урожайности ваших полей.
]

#v(0.5cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  align(left)[
    #image("decor-body.png", width: 320pt)
  ],
  align(right + horizon)[
    #text(size: 14pt, weight: "bold", fill: accent)[Коммерческое] \
    #text(size: 14pt, weight: "bold", fill: accent)[предложение]
    #v(0.5cm)
    #text(size: 10pt)[Кому:] \
    #text(size: 12pt, weight: "bold")[#client-name]
    #v(0.3cm)
    #text(size: 10pt)[Регион:] \
    #text(size: 11pt, weight: "bold")[#region]
    #v(0.3cm)
    #text(size: 10pt)[Общая площадь:] \
    #text(size: 11pt, weight: "bold")[#fmt(total-area) га]
    #v(0.2cm)
    #text(size: 9pt, fill: rgb("#555555"))[
      Сортов: #entries.len() |
      #for (idx, e) in entries.enumerate() [
        #e.variety.name#if idx < entries.len() - 1 [, ]
      ]
    ]
  ],
)

#v(1cm)

#align(center)[
  #image("team-photo.png", width: 100%)
]

// ============================================================
// ДЛЯ КАЖДОГО СОРТА: КАРТОЧКА + ТЕХНОЛОГИЧЕСКАЯ КАРТА
// ============================================================

#for (entry-idx, entry) in entries.enumerate() {

  let variety = entry.variety
  let area-ha = entry.area_ha
  let pain-label = entry.pain_label
  let pain-argument = entry.pain_argument
  let calculation = entry.calculation
  let seeds = calculation.seeds
  let grand-total = calculation.grand_total

  // ── СТРАНИЦА: КАРТОЧКА СОРТА ──
  pagebreak()
  page-header()
  v(0.3cm)

  // Получатель + номер секции
  text(size: 10pt, weight: "bold")[Кому: #client-name]
  h(1fr)
  text(size: 10pt)[Сорт #str(entry-idx + 1) из #str(entries.len()) | #fmt(area-ha) га]

  v(0.3cm)

  align(center)[
    text(size: 22pt, weight: "bold", fill: teal)[#variety.name]
  ]

  v(0.3cm)

  // Карточка
  block(
    width: 100%,
    fill: light-bg,
    radius: 6pt,
    inset: 16pt,
  )[
    text(size: 16pt, weight: "bold", fill: accent)[#variety.name]
    h(1fr)
    text(size: 10pt, fill: teal)[#variety.quality_class]

    v(0.3cm)
    text(size: 9pt, fill: rgb("#555555"))[#variety.biotype]
    v(0.4cm)

    // Цифры
    grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 12pt,
      block(fill: white, radius: 4pt, inset: 10pt, width: 100%)[
        #text(size: 8pt, fill: rgb("#888888"))[Средняя урожайность]
        #linebreak()
        #text(size: 20pt, weight: "bold", fill: accent)[
          #if variety.yield_avg != none [#fmt-dec(variety.yield_avg)]
        ]
        #text(size: 10pt, fill: rgb("#555555"))[ ц/га]
      ],
      block(fill: white, radius: 4pt, inset: 10pt, width: 100%)[
        #text(size: 8pt, fill: rgb("#888888"))[Максимальная]
        #linebreak()
        #text(size: 20pt, weight: "bold", fill: teal)[
          #if variety.yield_max != none [#fmt-dec(variety.yield_max)]
        ]
        #text(size: 10pt, fill: rgb("#555555"))[ ц/га]
      ],
      block(fill: white, radius: 4pt, inset: 10pt, width: 100%)[
        #text(size: 8pt, fill: rgb("#888888"))[Производственная]
        #linebreak()
        #text(size: 20pt, weight: "bold", fill: accent)[
          #if variety.yield_production != none [#fmt-dec(variety.yield_production)]
          #if variety.yield_production == none [—]
        ]
        #text(size: 10pt, fill: rgb("#555555"))[ ц/га]
      ],
    )

    v(0.4cm)

    if variety.protein_percent != none [
      #text(size: 9pt)[Протеин: *#fmt-dec(variety.protein_percent)%*]
      #h(1cm)
    ]
    if variety.gluten_percent != none [
      #text(size: 9pt)[Клейковина: *#fmt-dec(variety.gluten_percent)%*]
    ]

    v(0.4cm)

    text(size: 10pt, weight: "bold", fill: teal)[Ключевые преимущества:]
    v(0.15cm)
    for adv in variety.key_advantages {
      text(size: 9pt)[• ] + text(size: 9pt, adv) + linebreak()
    }

    v(0.3cm)
    text(size: 9pt, fill: rgb("#555555"))[
      Госреестр с #variety.registry_since г. | Регионы: #variety.region_names.join(", ")
    ]
  ]

  v(0.5cm)

  // Блок «Фокус»
  block(
    width: 100%,
    fill: highlight-yellow,
    radius: 6pt,
    inset: 14pt,
  )[
    text(size: 11pt, weight: "bold", fill: accent)[Фокус: #pain-label]
    v(0.2cm)
    text(size: 9.5pt)[#pain-argument]
  ]

  // ── СТРАНИЦА: ТЕХНОЛОГИЧЕСКАЯ КАРТА ──
  pagebreak()
  page-header()
  v(0.3cm)

  align(center)[
    text(size: 18pt, weight: "bold", fill: teal)[
      Технологическая карта: #variety.name
    ]
  ]

  text(size: 9pt, fill: rgb("#555555"))[
    Площадь: *#fmt(area-ha) га* | Норма высева: *#tech.seeding_rate кг/га*
    | Семена: *#fmt-dec(seeds.volume_tonnes, digits: 1) т*
  ]

  v(0.3cm)

  // Таблица
  {
    set table(
      stroke: 0.5pt + table-border-color,
      inset: 5pt,
    )

    let hcell(content) = table.cell(
      fill: table-header-bg,
      text(fill: table-header-fg, weight: "bold", size: 8pt)[#content],
    )

    let season-cell(content) = table.cell(
      colspan: 7,
      fill: season-bg,
      text(fill: teal, weight: "bold", size: 9pt)[#content],
    )

    table(
      columns: (0.4fr, 2fr, 0.8fr, 0.7fr, 0.8fr, 0.9fr, 1fr),
      align: (center + horizon, left + horizon, center + horizon, center + horizon, center + horizon, right + horizon, right + horizon),

      hcell[№],
      hcell[Препарат],
      hcell[Категория],
      hcell[Норма],
      hcell[Объём],
      hcell[Цена/ед.],
      hcell[Стоимость],

      // Семена
      table.cell(fill: highlight-yellow)[],
      table.cell(fill: highlight-yellow)[
        #text(weight: "bold", size: 9pt)[Семена: #seeds.variety]
      ],
      table.cell(fill: highlight-yellow)[#text(size: 8pt)[семена]],
      table.cell(fill: highlight-yellow)[#text(size: 8pt)[#tech.seeding_rate кг/га]],
      table.cell(fill: highlight-yellow)[#text(size: 8pt)[#fmt-dec(seeds.volume_tonnes, digits: 1) т]],
      table.cell(fill: highlight-yellow)[#text(size: 8pt)[#fmt(seeds.price_per_tonne)]],
      table.cell(fill: highlight-yellow)[#text(weight: "bold", size: 8pt)[#fmt(seeds.cost)]],

      // Сезоны
      ..for season in calculation.seasons {
        let cells = (season-cell(season.name),)
        for treatment in season.treatments {
          for (pidx, p) in treatment.products.enumerate() {
            let bg = if calc.rem(pidx, 2) == 0 { white } else { table-alt-row }
            let num-text = if pidx == 0 and treatment.num != none {
              str(treatment.num)
            } else { "" }
            let phase-info = if pidx == 0 { treatment.phase } else { "" }
            cells.push(table.cell(fill: bg)[#text(size: 8pt)[#num-text]])
            cells.push(table.cell(fill: bg)[
              #text(size: 8pt)[
                #text(weight: if pidx == 0 { "bold" } else { "regular" })[#p.name]
                #if phase-info != "" [
                  \ #text(size: 7pt, fill: rgb("#888888"))[фаза #phase-info]
                ]
              ]
            ])
            cells.push(table.cell(fill: bg)[#text(size: 7pt)[#p.category]])
            cells.push(table.cell(fill: bg)[#text(size: 8pt)[#fmt-dec(p.rate) #p.unit]])
            cells.push(table.cell(fill: bg)[#text(size: 8pt)[#fmt-dec(p.volume, digits: 1)]])
            cells.push(table.cell(fill: bg)[#text(size: 8pt)[#fmt(p.price)]])
            cells.push(table.cell(fill: bg)[#text(size: 8pt)[#fmt(p.cost)]])
          }
        }
        cells
      },

      // Итого по сорту
      table.cell(colspan: 6, fill: white)[
        #align(right)[#text(weight: "bold", size: 10pt, fill: teal)[ИТОГО (#variety.name, #fmt(area-ha) га)]]
      ],
      table.cell(fill: highlight-yellow)[
        #align(right)[#text(weight: "bold", size: 10pt, fill: teal)[#fmt(grand-total) руб.]]
      ],
    )
  }

  v(0.3cm)

  // Стоимость на гектар
  {
    let cost-per-ha = calc.round(grand-total / area-ha, digits: 0)
    align(right)[
      text(size: 10pt)[Стоимость на 1 га: *#fmt(cost-per-ha) руб/га*]
    ]
  }
}

// ============================================================
// ФИНАЛЬНАЯ СТРАНИЦА: СВОДКА + ПОДПИСЬ
// ============================================================
#pagebreak()
#page-header()
#v(0.5cm)

#align(center)[
  #text(size: 20pt, weight: "bold", fill: teal)[Сводка по предложению]
]

#v(0.5cm)

// Сводная таблица
#set table(
  stroke: 0.5pt + table-border-color,
  inset: 7pt,
)

#let shcell(content) = table.cell(
  fill: table-header-bg,
  text(fill: table-header-fg, weight: "bold", size: 9pt)[#content],
)

#table(
  columns: (0.4fr, 2fr, 1.2fr, 1.2fr, 1.5fr, 1.5fr),
  align: (center + horizon, left + horizon, center + horizon, right + horizon, right + horizon, right + horizon),

  shcell[№],
  shcell[Сорт],
  shcell[Площадь (га)],
  shcell[Семена (т)],
  shcell[Стоимость (руб.)],
  shcell[Руб./га],

  ..for (idx, entry) in entries.enumerate() {
    let bg = if calc.rem(idx, 2) == 0 { white } else { table-alt-row }
    let cost-ha = calc.round(entry.calculation.grand_total / entry.area_ha, digits: 0)
    (
      table.cell(fill: bg)[#str(idx + 1)],
      table.cell(fill: bg)[#text(weight: "bold")[#entry.variety.name]],
      table.cell(fill: bg)[#fmt(entry.area_ha)],
      table.cell(fill: bg)[#fmt-dec(entry.calculation.seeds.volume_tonnes, digits: 1)],
      table.cell(fill: bg)[#fmt(entry.calculation.grand_total)],
      table.cell(fill: bg)[#fmt(cost-ha)],
    )
  },

  // Итого
  table.cell(fill: highlight-yellow)[],
  table.cell(fill: highlight-yellow)[#text(weight: "bold", size: 10pt, fill: teal)[ИТОГО]],
  table.cell(fill: highlight-yellow)[#text(weight: "bold")[#fmt(total-area)]],
  table.cell(fill: highlight-yellow)[],
  table.cell(fill: highlight-yellow)[#text(weight: "bold", size: 10pt, fill: teal)[#fmt(total-cost)]],
  table.cell(fill: highlight-yellow)[
    #let avg-cost = calc.round(total-cost / total-area, digits: 0)
    #text(weight: "bold")[#fmt(avg-cost)]
  ],
)

#v(1cm)

// Следующий шаг
#block(
  width: 100%,
  fill: light-bg,
  radius: 6pt,
  inset: 14pt,
)[
  #text(size: 12pt, weight: "bold", fill: teal)[Следующий шаг]
  #v(0.2cm)
  #text(size: 10pt)[
    Для обсуждения условий и организации поставки свяжитесь с вашим персональным менеджером.
    Мы готовы организовать выезд агронома для оценки полей и подбора оптимальной технологии.
  ]
]

#v(1cm)

// Подпись
#grid(
  columns: (1.5fr, 1fr),
  [
    #text(size: 10pt)[С уважением,]
    #v(0.3cm)
    #if manager-name != "" [
      #text(size: 11pt, weight: "bold")[#manager-name] \
    ]
    #text(size: 9pt)[Официальный партнёр АО «Щёлково Агрохим»]
    #v(0.5cm)
    #if email != "" [
      #text(size: 9pt)[E-mail: #email] \
    ]
    #if phone != "" [
      #text(size: 9pt)[Тел.: #phone]
    ]
  ],
  align(right)[
    // #image("stamp.png", width: 159pt)
  ],
)
