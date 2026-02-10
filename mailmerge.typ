// Mail merge with Typst: reads fakenames.xml directly, produces PDF.

#let xml_file = sys.inputs.at("xml", default: "fakenames.xml")
#let data = xml(xml_file)
#let records = data.first().children.filter(c => type(c) == dictionary)

#set page(paper: "a4", margin: (top: 15mm, bottom: 20mm, left: 20mm, right: 20mm))
#set text(font: "Helvetica", size: 11pt, hyphenate: true, lang: "en")
#set par(justify: true, leading: 0.65em)

#for (i, r) in records.enumerate() {
  let a = r.attrs
  if i > 0 { pagebreak() }

  // Logo top-right
  place(top + right, image("logo.png", height: 35mm))

  // Sender info, right-aligned below logo
  place(top + right, dy: 40mm,
    align(right, text(size: 10pt)[
      Print Company & Office \
      61556 W 20th Ave \
      Seattle King WA 98104
      #v(3mm)
      206-711-6498 \
      206-395-6284
      #v(3mm)
      jbiddy\@printcompany.com \
      www.printcompany.com
    ])
  )

  // Recipient left
  v(40mm)
  set par(justify: false)
  block(width: 105mm)[
    #a.at("first_name") #a.at("last_name") \
    #a.at("address") \
    #a.at("city"), #a.at("state") #a.at("zip")
  ]

  v(25mm)

  block(width: 105mm)[November 6, 2014]

  v(8mm)

  block(width: 105mm)[Dear #a.at("first_name") #a.at("last_name"),]

  v(5mm)

  set par(justify: true)
  block(width: 105mm)[
    but I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?
  ]

  v(5mm)

  set par(justify: false)
  block(width: 105mm)[Yours faithfully,]

  v(10mm)

  block(width: 105mm)[Jani Biddy]
}
