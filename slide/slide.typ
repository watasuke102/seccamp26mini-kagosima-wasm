#import "@watasuke102/slide:1.2.0": *
#import "@preview/cetz:0.5.2"
#show: slides.with()
#set underline(offset: 0.18em)

#let quotebox(body) = box(
  stroke: (left: 5pt + white),
  inset: (left: 4mm, y: 2mm),
  body,
)
#let lr(left, right) = block(below: 0.7em, above: 0.7em, stack(
  dir: ltr,
  spacing: 0.1em,
  left,
  right,
))
#let then(content) = lr([→], content)

#template_title_main(
  text(size: 72pt)[WebAssembly入門],
  [2026-10-03 | セキュリティ・キャンプ 2026 ミニ（鹿児島開催）\ わたすけ (\@watasuke1024)],
)
#for i in range(2) {
  let col = if i == 0 { white } else { green }
  template_bio_with_humanform[
    #text(1.6em)[*渡辺 耀介*] #text(fill: gray2)[WATANABE Yosuke]
    - インターネットで *わたすけ* (\@watasuke1024) として生活しています
    - 宇部高専 制御情報工学科 #text(0.85em)[(～2025.03)]\
      → 筑波大学 情報メディア創成学類 #text(0.85em)[(*3年次編入*)]
    - #text(0.9em)[専攻分野：ヒューマンコンピュータインタラクション]
      - #text(0.9em)[UIとかインタフェースとかそのへん]
      - #text(0.9em)[僕は#text(col)[*xR* #text(0.8em)[(AR/VR等)] *による作業環境*]について研究中]
    - 趣味：*ソフトウェア開発*、作曲、料理
  ]
}
#template_center(
  upper: [== 人生の目標：可搬性の高い環境を作りたい],
  caption: [#link(
    "https://pkm.watasuke.net/notes/%E5%8F%AF%E6%90%AC%E6%80%A7%E3%81%AE%E9%AB%98%E3%81%84%E7%92%B0%E5%A2%83%E3%82%92%E4%BD%9C%E3%82%8B",
  )[pkm.watasuke.net]],
  box(stroke: 2pt + white, image("img/pkm-watasuke-net.jpg")),
)
#template_basic[
  == どこでも作業したい！
  - 中学生時代：
    - 電子辞書でメモ帳を起動してプログラムを書く
    - パソコン部で使うソフトをUSBに入れて持ち運び
  - 高専時代〜
    - サーバーを契約して、そこにSSHして全ての開発をやる
      - #text(0.8em)[スペックが低くて無理だった]
    - 自宅サーバーにVPN経由でSSH
      - 今はこれがち
]
#for i in range(6) {
  template_basic[
    == ところで
    #(
      (
        [- 高専1年生の冬、英単語テストに苦しめられていた],
        [
          - 単語帳アプリにインポートするための csv を作って\ Googleドライブに上げてクラスメイトに共有していた
        ],
        [- すると、typo や抜けが頻繁に発生する],
        [- すでに csv をインポートしている人は手作業で修正],
        [- 面倒だから英単語の一問一答サービスでも作るか！ｗ],
      )
        .slice(0, i)
        .join()
    )
  ]
}
#for i in range(2) {
  template_basic[
    == Webアプリ、すばらしい
    - クラスメイトのほとんどはiPhoneユーザ
    - 僕はiOSアプリの開発に必要なmacOSを使えない
    - ほなWebアプリか……
    #if i == 1 {
      then[ちょっとCSSを頑張るだけで*スマホのOSどころか\ PC/スマホという機種差すら無視してアプリを作れる*！

        どこでも使える（家ではPC、外出先ではスマホ）\ == 可搬性が高い のでは！？]
    }
  ]
}
#template_basic[
  == Webアプリ、すばらしい
  - なので、Webを前提としてプログラミング言語を作った
    - コンパイル結果がWebAssembly
  - Rustで処理系を書いたので\ *コンパイラ自体もWebAssemblyとして出力できる*
  - Webブラウザで簡単に言語を試せる！
    - コンパイルから実行まですべてWebブラウザで行える
]
#template_center(
  box(stroke: 2pt + white, image("img/settlang-playground.jpg")),
  caption: [
    #link("https://watasuke102.github.io/settlang/")[watasuke102.github.io/settlang]\
    #text(0.9em)[Settlang - 変数の可変性をsetterの有無により表現する言語]
  ],
)
#template_basic[
  == Web技術、すばらしい
  ↑と思ったのでWebAssemblyの講義をやります\
  よろしくお願いします
]

#template_basic[
  == 講義のめあて
  1. WebAssembly という切り口から *Web 技術*に触れる
  2. *バイナリ*という概念を知って、親しみを持つ
  3. 「*仕様書を読む*」という選択肢を思い浮かべられるようになる
]

#let wasm_logo = place(right + bottom, image("img/web-assembly-icon.svg", height: 35mm))

#template_section("")
#template_section("WebAssemblyとは")
#template_basic[
  == WebAssemblyとは
  - Webブラウザ*等*で動作するもの
  - ポータブルさを意識した仕様策定が行われている
    - Web ブラウザに限らず様々な環境で動く
  - *サンドボックス環境で動作*するため安全
    - 明示的に与えたものにしかアクセスできない
  #wasm_logo
]
#template_basic[
  == WebAssemblyとは
  - 略して#text(fill: green)[*Wasm*]
    - 公式サイト#footnote[https://webassembly.org]にも書いてある：\ *WebAssembly* (abbreviated *Wasm*)
    - WASMではない！
  // from https://github.com/carlosbaraza/web-assembly-logo/blob/f0f411529c1dafffa233be1bd95b80b79144b675/dist/icon/web-assembly-icon.svg
  #wasm_logo
]
#template_basic[
  == Wasmは速い
  本当に？
]
#template_center(
  caption: [Kotlin/JVMのほうが速い #text(size: 0.9em, fill: gray1)[(バーが短いほどかかった時間が短い)]],
  [
    #box(
      clip: true,
      inset: (top: -23mm, bottom: -86mm),
      image("img/kotlin-wasm-performance-compose.jpg"),
    )
    #place(top + left, dx: 5mm, dy: 40mm, box(width: 108mm, height: 83mm, stroke: 6pt + green))
  ],
)
#template_basic[
  == Wasmは速い
  本当に？→部分的に*いいえ*

  Wasmにしたから絶対に速くなる！というわけでもない
]
#template_basic[
  == じゃあなぜWasm？
  *様々な言語から出力できる*
  - ポータブルな仕様のおかげ
  - C++ (Emscripten), Rust, Go, C\#, Kotlin, MoonBit, Java...#footnote[https://github.com/appcypher/awesome-wasm-langs にたくさん載っている]
  - 自分が慣れている言語でWeb開発ができる
]
#template_basic[
  == じゃあなぜWasm？
  *様々な言語から出力できる*
  - プラグインとしてWasmをサポートすると、\ 開発者に言語を強制しなくてよくなる
    - 例) TypstはWasm製プラグインをサポートしている
    - 言語それぞれにSDKを用意する必要がない！
]

#for i in range(2) {
  template_basic[
    == 応募課題
    #text(
      fill: if i == 1 { green } else { white },
      weight: if i == 1 { "black" } else { "regular" },
    )[WebAssembly 形式にコンパイルできるプログラミング言語]を\ 1 つ選んで、以下に取り組んでください。

    #set text(size: 0.99em)
    #set enum(numbering: "(1)")
    2. 選んだプログラミング言語を用いて*「引数として数字を 2 つ\ 受け取って、それらを足した数を返す」という関数*を\ 作ってください。#text(fill: gray)[書いたプログラムを答えてください。]
    3. (2) で作成した関数を使って *1+2 を計算した結果を、\ 標準出力に出力するプログラム*を書いてください。#text(fill: gray)[そして、\ そのプログラムを WebAssembly 形式で出力してみてください。]
  ]
}
#template_center(
  upper: [== 言語の多様性],
  image("img/pre-assignment-languages.pdf"),
)

#template_basic[
  == 想定回答
  C++
  ```cpp
  int32_t add(int32_t lhs, int32_t rhs) {
    return lhs + rhs;
  }

  int main() {
    std::println("{}", add(1, 2));
  }
  ```
  #text(fill: gray)[※ `lhs` = Left Hand Side]
]
#let rust_sample_code = template_basic[
  == 想定回答
  Rust（再掲）
  ```rs
  fn add(lhs: i32, rhs: i32) -> i32 {
    lhs + rhs
  }

  fn main() {
    println!("{}", add(1, 2));
  }
  ```
]
#rust_sample_code
#template_basic[
  == int32_t / i32 って何？
  #cetz.canvas({
    import cetz.draw: *
    set-style(line: (stroke: 3pt))
    content((0, 0), anchor: "west", name: "main")[*符号付き32bit整数*のこと]

    line((0, -0.6), (rel: (3.7, 0)), stroke: green, name: "signed")
    line("signed", (rel: (0, -3.3)), stroke: green, name: "to-signed")
    content(("main.west", "|-", "to-signed.end"), anchor: "north-west")[マイナスも表現できる]

    line((3.9, -0.6), (rel: (4.8, 0)), stroke: (paint: blue, dash: "dashed"), name: "32bit")
    line("32bit", (rel: (0, -1.3)), stroke: (paint: blue, dash: "dashed"), name: "to32")
    content(("main", "|-", "to32.end"), anchor: "north-west")[32個の0/1 (bit) により整数を表す]
  })
  #text(fill: gray1, size: 0.8em)[符号なし64bit整数というのもある（uint64_t, u64）]
]
#template_center(table(
  columns: 3,
  stroke: none,
  row-gutter: 3mm,
  column-gutter: 8mm,
  [], [符号付き], [符号なし],
  table.hline(stroke: 2pt + white),
  [16bit], [-32,768〜32,767], [0〜65,535],
  table.hline(stroke: 1pt + gray),
  [32bit], [-2,147,483,648〜2,147,483,647], [0〜4,294,967,295],
  table.hline(stroke: 1pt + gray),
  [64bit],
  text(size: 0.7em)[-9,223,372,036,854,775,808〜9,223,372,036,854,775,807],
  text(size: 0.7em)[0〜18,446,744,073,709,551,615#footnote[1,844京 6,744兆 737億 955万 1,615]],
))
#template_basic[
  == 2進数とビット/バイト
  - 我々がよく使うのは10進数\
    - それぞれの位は0〜9によって表される
    - 右からN ($>=0$) 番目の位に $10^N$ をかけて足すと\ 値が得られる
    例：1234

    $1234
    &= 1 times 10^3 + 2 times 10^2 + 3 times 10^1 + 4 times 10^0\
    &= 1000 + 200 + 30 + 4\
    &= 1234$
]
#template_basic[
  == 2進数とビット/ バイト
  - コンピュータでは*2進数*が用いられる
    - それぞれの位は0, 1によって表される
    - 右からN ($>=0$) 番目の位に $2^N$ をかけて足すと\ 値が得られる
    例：#strong[0b]010101

    $010101
    &= 0 times 2^5 + 1 times 2^4 + 0 times 2^3 + 1 times 2^2 + 0 times 2^1 + 1 times 2^0\
    &= 0 + 16 + 0 + 4 + 0 + 1\
    &= 21$
]
#template_basic[
  == 2進数とビット/ バイト
  - コンピューターでは、2進数の1桁を*ビット* (bit) と呼ぶ
  - 多くの場合#footnote[昔はそうではなかったので8ビットのことをオクテットと呼んだりもしていたらしい]、8ビットをまとめて*1バイト* (byte) と呼ぶ
    - 例) 32 bit == 4 byte
]
#template_basic[
  == 16進数
  - 2進数は長すぎる！→*16進数*を用いてコンパクトに表す
    - それぞれの位は0〜9とa〜fの16文字によって表される
    - 右からN ($>=0$) 番目の位に $16^N$ をかけて足す
  - 1バイトをちょうど2桁で表せて、うれしい

    例：#strong[0x]1af #text(fill: gray)[(a == 10, f == 15)]

    $1"af"
    &= 1 times 16^2 + 10 times 16^1 + 15 times 16^0\
    &= 256 + 160 + 15\
    &= 431$
]

#rust_sample_code
#for i in range(2) {
  template_basic[
    == 想定回答
    Rust
    ```bash
    $ rustc --target wasm32-wasip2 add.rs
    $ wasmtime add.wasm
    3
    ```
    #if i == 1 {
      place(left + top, dx: 53mm, dy: 47mm, box(width: 44mm, height: 14mm, stroke: 4pt + red))
      place(left + top, dx: 56mm, dy: 63mm, [↑ これ何？])
    }
  ]
}
#template_basic[
  == `file`コマンド
  ファイルがどういうものなのか教えてくれる
  ```
  $ file /usr/bin/ls
  /usr/bin/ls: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=4e297d3b427342e1da6b66f5ca0fd279f43f3afe, for GNU/Linux 4.4.0, stripped
  $ file add.rs
  add.rs: C source, ASCII text
  ```
]
#for i in range(2) {
  template_basic[
    == add.wasm の形式
    ```
    $ file add.wasm
    add.wasm: WebAssembly (wasm) binary version 0x1000d (component)
    ```
    #if i == 1 {
      place(top + left, dx: 140mm, dy: 28mm, box(stroke: 5pt + red, width: 34mm, height: 15mm))
    }
  ]
}
#template_basic[
  == Wasmとは「本当は」何なのか
  #quotebox[
    WebAssembly (abbreviated Wasm) is a\ #text(fill: green)[*binary instruction format*] for a stack-based virtual machine
  ]
  *バイナリ*の命令フォーマット
]
#template_basic[
  == どういうこと？
  こういうこと#footnote[odはファイルの中身を指定した形式により出力するコマンド。\ -tはフォーマットを指定するもので、x1とするとhex (16進数) を1つずつ表示する]
  ```
  $ od -tx1 add.wasm | head -n5
  0000000 00 61 73 6d 0d 00 01 00 07 24 01 42 04 01 6f 02
  0000020 73 73 01 70 00 01 40 00 00 01 04 00 0f 67 65 74
  0000040 2d 65 6e 76 69 72 6f 6e 6d 65 6e 74 01 02 0a 20
  0000060 01 00 1b 77 61 73 69 3a 63 6c 69 2f 65 6e 76 69
  0000100 72 6f 6e 6d 65 6e 74 40 30 2e 32 2e 31 32 05 00
  ```
]
#template_basic[
  == Wasm バイナリ形式
  - ブラウザ等に読み込ませて実行するもの
  - 人間が読むことを想定していない
  #then[わかりづらすぎるので*テキスト形式*というものもある]
]

#template_section("Wasm テキスト形式")
#template_basic[
  == はじめる前に
  環境構築はしてきましたか？
]
#template_basic[
  == 環境構築（Windows 11）
  1. スタートボタン (画面端のタスクバーにあるWindowsロゴ) を右クリック
  2. "ターミナル" #text(size: 0.80em)[(もしくは "PowerShell")] と書かれた項目をクリック
  #show raw: set text(size: 0.82em)
  3. "ターミナルに入力→Enter" を1行ずつやる：
  ```
  cd
  pacman -S --noconfirm git wasm-tools wasmtime npm nodejs
  git clone https://github.com/watasuke102/seccamp26mini-kagosima-wasm
  ```
]

#template_basic[
  == はじめる前に
  してきた人へ：CLIコマンドが使える環境を用意してください

  事前の指示どおりに環境構築を行った人\ （Windows + WSLの人）は以下のようにして起動
  1. スタートボタン (画面端のタスクバーにあるWindowsロゴ) を右クリック
  2. "ターミナル" #text(size: 0.80em)[(もしくは "PowerShell")] と書かれた項目をクリック
  3. `wsl -d archlinux` と入力してEnter
]
#template_basic[
  #show raw: set text(size: 0.82em)
  == はじめる前に
  "ターミナルに入力→Enter" を1行ずつやる：
  ```
  cd
  pacman -Syu --noconfirm && pacman -S git --noconfirm
  git clone https://github.com/watasuke102/seccamp26mini-kagosima-wasm
  ```
]
#template_center(
  upper: [
    == まずは書いてみよう
    #text(fill: green)[*waspl*]というWebアプリを使います\
    #link("https://watasuke102.github.io/waspl/")[*watasuke102.github.io/waspl*]にアクセス！
    #v(3mm)
  ],
  caption: [こういうページが見える],
  box(
    stroke: 2pt + white,
    image("img/waspl-main.jpg"),
  ),
)
#template_basic[
  == まずは書いてみよう
  画面左側がエディタになっています

  1. 入力されているコードを全て消す
  2. 以下の1行を入力：
    ```lisp
    (module)
    ```
  3. Ctrl+Enterもしくは右上の「Parse」ボタンを押す
]
#template_center(
  upper: [
    == まずは書いてみよう
    - こうなるはず
    - 左はWasmテキスト形式
    - 右は*コンパイルされたWasmバイナリ形式*
  ],
  box(stroke: 2pt + white, image("img/waspl_module-only.jpg")),
)
#template_basic[
  == Wasmバイナリ形式
  ```
  00	61	73	6D	01	00	00	00
  ```
  何これ？
]
#for i in range(2) {
  template_basic[
    == 思い出し
    Rustから作成したadd.wasm のバイナリってどうなってたっけ
    ```
    $ od -tx1 add.wasm | head -n5
    0000000 00 61 73 6d 0d 00 01 00 07 24 01 42 04 01 6f 02
    0000020 73 73 01 70 00 01 40 00 00 01 04 00 0f 67 65 74
    0000040 2d 65 6e 76 69 72 6f 6e 6d 65 6e 74 01 02 0a 20
    0000060 01 00 1b 77 61 73 69 3a 63 6c 69 2f 65 6e 76 69
    0000100 72 6f 6e 6d 65 6e 74 40 30 2e 32 2e 31 32 05 00
    ```
    #if i == 1 {
      place(
        dy: -37mm,
        box(
          stroke: 2pt + white,
          image("img/waspl_module-only_zoomed.jpg", width: 100%),
        ),
      )
      place(dx: 40mm, dy: -62mm, box(stroke: 5pt + red, width: 115mm, height: 12mm))
      place(dx: 176mm, dy: -10mm, box(stroke: 5pt + red, width: 89mm, height: 11mm))
    }
  ]
}
#let magic_num_stroke = (thickness: 3pt, paint: green, dash: "dotted")
#let version_stroke = 4pt + red
#for i in range(2) {
  template_basic[
    == 似ているけど違う
    なぜ？
    ```
    0000000 00 61 73 6d 0d 00 01 00 07 24 01 42 04 01 6f 02
    ```
    #place(top + left, dx: 40mm, dy: 36mm, box(stroke: magic_num_stroke, width: 55mm, height: 12mm))
    #place(top + left, dx: 98mm, dy: 36mm, box(stroke: version_stroke, width: 56mm, height: 12mm))

    #box(
      stroke: 2pt + white,
      clip: true,
      inset: (left: -170mm, top: -17mm),
      image("img/waspl_module-only_zoomed.jpg", height: 50mm),
    )
    #place(top + left, dx: 49mm, dy: 75mm, box(
      stroke: magic_num_stroke,
      width: 51.5mm,
      height: 12mm,
    ))
    #place(top + left, dx: 103mm, dy: 75mm, box(stroke: version_stroke, width: 53mm, height: 12mm))

    #if i == 1 [
      #then[バイナリの構造は*仕様書に書いてある*]
    ]
  ]
}
#for e in (
  (
    image("img/goto-wasm-spec_top.jpg"),
    [ページ上部の*"Specs"*をクリック\ #text(fill: gray)[(SPECification == 仕様書 のこと)]],
  ),
  (
    image("img/goto-wasm-spec_spec.jpg"),
    [WebAssembly Specification],
  ),
  (
    [
      #image("img/wasm-spec_top.jpg")
      #place(dx: 74mm, dy: -56.9mm, box(stroke: 3pt + red, width: 23mm, height: 4.5mm))
    ],
    [Binary Format #text(fill: gray)[(メニューにText Formatもありますね)]],
  ),
  (
    image("img/goto-wasm-spec_modules.jpg", height: 100%),
    [下の方にある "Modules"],
  ),
) {
  template_center(
    upper: [
      == 仕様書を読もう！
    ],
    caption: e.at(1),
    e.at(0),
  )
}
#for i in range(3) {
  template_center(
    upper: [
      == 仕様書を読もう！
    ],
    caption: [下までスクロールするとこれが出てくる],
    [
      #image("img/wasm-spec_module.jpg")
      #set text(fill: black)
      #if i == 1 {
        place(dx: 64mm, dy: -18mm, box(stroke: 5pt + red, width: 63mm, height: 7mm))
        place(dx: 129mm, dy: -21mm, box(
          fill: red,
          inset: (bottom: 3.5mm, rest: 2mm),
          stack(
            dir: ltr,
            align(top)[←],
            [Wasmモジュールは\ *magic, version#text(size: 0.8em)[という]順番*で並ぶ],
          ),
        ))
      } else if i == 2 {
        place(dx: 62mm, dy: -31mm, box(stroke: 5pt + red, width: 80mm, height: 13mm))
        place(dx: 146mm, dy: -31mm, box(
          fill: red,
          inset: 2mm,
          stack(
            dir: ltr,
            align(top)[←],
            [*magic, version*は\ ここで定義されている],
          ),
        ))
      }
    ],
  )
}
#template_basic[
  == magicとは
  #text(fill: green)[*マジックナンバー*]のこと
  - *ファイルがどのような種類なのかを示す*特定の数字
    - `file` コマンドはこれを見てファイルの種類を\ 判定することが多い
  - たいていファイルの冒頭にある
]
#template_center(
  upper: [
    == マジックナンバーの例：PNG
  ],
  caption: [#link("https://www.w3.org/TR/png/#A-Media-type")[W3CによるPNGの仕様書]より],
  [
    #image("img/png-spec.jpg", height: 100%)
    #place(left + top, dx: 80mm, dy: 53mm, box(stroke: 5pt + red, width: 100mm, height: 12mm))
  ],
)
#template_basic[
  == マジックナンバーの例：PNG
  ```
  $ file image.png
  image.png: PNG image data, 1920 x 1080, 8-bit/color RGB, non-interlaced

  $ od -tx1 image.png | head -n3
  0000000 89 50 4e 47 0d 0a 1a 0a 00 00 00 0d 49 48 44 52
  0000020 00 00 07 80 00 00 04 38 08 02 00 00 00 67 b1 56
  0000040 14 00 00 00 20 63 48 52 4d 00 00 7a 26 00 00 80
  ```
  #place(dx: 40mm, dy: -37mm, box(stroke: 5pt + red, width: 115mm, height: 12mm))
  // #box(
  //   clip: true,
  //   inset: (top: -20mm, bottom: -27mm, left: -7mm, right: -21mm),
  //   image("img/png-spec.jpg"),
  // )
]
#template_basic[
  #show footnote.entry: set text(0.7em)
  == 結論
  ```
  0000000 00 61 73 6d 0d 00 01 00 07 24 01 42 04 01 6f 02
  ```
  #place(dx: 40mm, dy: -21mm, box(
    stroke: magic_num_stroke,
    width: 55mm,
    height: 12mm,
  ))
  #place(dx: 98mm, dy: -21mm, box(stroke: version_stroke, width: 55mm, height: 12mm))
  - #underline(stroke: magic_num_stroke)[マジックナンバー]が最初の4バイト
  - 差異が発生していたその後の4バイトは#underline(stroke: version_stroke)[バージョン]#footnote[厳密には違う（参考：スライド最後の補足資料）]
]

#template_section("もっとWasmを書いてみる")
#template_basic[
  == もっとWasmを書いてみる
  やっぱり*関数*があるとうれしいですよね
  1. 左側のエディタに以下を入力：
    ```lisp
    (module
      (func)
    )
    ```
  3. Ctrl+Enterもしくは右上の「Parse」ボタンを押す
]
#template_center(
  caption: [出力が増えた！],
  box(stroke: 2pt + white, image("img/waspl_empty-func.jpg")),
)
#template_basic[
  == もっとWasmを書いてみる
  `(func)`を2つにしてみると……？
  ```lisp
  (module
    (func)
    (func)
  )
  ```
]
#template_center(caption: [もっと増えた！], stack(
  dir: ttb,
  box(stroke: 2pt + white, image("img/waspl_empty-func.jpg", width: 90%)), //
  scale(y: 30%, rotate(180deg, polygon.regular(stroke: none, fill: white, size: 18mm))), //
  box(stroke: 2pt + white, image("img/waspl_empty-func2.jpg", width: 90%)), //
))
#template_center(
  upper: [
    == Wasmバイナリのしくみ
    Wasmバイナリは#text(fill: green)[*セクション*]という塊の集合体
  ],
  [
    #image("img/wasm-spec_module-entire.jpg")
    #place(top + left, dx: 101mm, dy: 18mm, box(stroke: 5pt + red, width: 40mm, height: 66mm))
  ],
)
#template_basic[
  == セクションとは？
  次のようなバイト列 #footnote[https://webassembly.github.io/spec/core/binary/modules.html#sections]：

  $
    "section"_N (X) ::= N:"byte" space "len":"u32" space "content"^*:X => "content"^*
  $
  つまり、
  1. セクションID
  2. セクションの中身の長さ
  3. セクションの中身
  という順に置かれる
]
#template_center(
  upper: [
    == セクションID？
    仕様書に書いてある：
  ],
  image("img/wasm-spec_section-id.jpg"),
)
#template_basic[
  == 確認してみよう
  コードをこう変えてみる
  ```lisp
  (module
    (func)
    (func (export "sample") (result i32)
      i32.const 12345
    )
  )
  ```
]
#template_center(
  upper: [
    == 確認してみよう
    *Wasmバイナリをダウンロード*して\ `wasm-tools dump module.wasm`を実行
  ],
  [
    #box(stroke: 2pt + white, image("img/waspl_sample.jpg", width: 100%))
    #place(top + left, dx: 184mm, dy: 15mm, box(stroke: 5pt + red, width: 35mm, height: 12mm))
  ],
)
#template_center(
  upper: [
    == やりかた（Windows 11+WSL）
    エクスプローラーで「Linux」を開く\
    *"archlinux"の中にある"root"フォルダ*にWasmを保存
  ],
  [
    #set block(below: 3mm)
    #set image(height: 67mm)
    #set text(size: 0.9em)
    #stack(
      dir: ltr,
      spacing: 3mm,
      [
        #image("img/win11_exp-left-bottom.jpg")
        エクスプローラ左下あたり
      ],
      [→],
      [
        #image("img/win11_wsl-arch.jpg")
        "Linux" をクリックするとこうなる
      ],
    )
  ],
)
#template_center(
  upper: [
    == やりかた（Windows 11+WSL）
    "ターミナルに入力→Enter" を1行ずつやる：
    ```
    cd
    wasm-tools dump [ダウンロードしたファイル名]
    ```
    #lr[※][ターミナルを1度閉じていた場合、最初に\ `wsl -d archlinux` を実行すること]
    #v(4mm)
  ],
  align(bottom, stack(
    dir: ltr,
    spacing: 5mm,
    box(stroke: 2pt + white, image("img/win11_wasm-tools-in-terminal.jpg", height: 100%)),
    [← 実行例],
  )),
)
#template_center(
  upper: [
    == 実行結果
  ],
  box(stroke: 2pt + white, image("img/wasm-dump_sample.jpg", height: 100%)),
)
#template_center(
  upper: [
    == セクション
    現在のセクションは主に4つ：
    1. *Type* セクション
    2. *Function* セクション
    2. *Export* セクション
    3. *Code* セクション
  ],
  [
    #box(stroke: 2pt + white, image("img/waspl_sample.jpg", width: 95%))
    #place(top + left, dx: 154mm, dy: 27mm, box(stroke: 5pt + red, width: 67mm, height: 9mm))
  ],
)
#template_center(
  upper: [
    == Type セクション
    - id: 1
    - どのような関数が含まれているか伝えるもの
  ],
  box(
    clip: true,
    inset: (top: -34mm, bottom: -229mm, right: -140mm),
    stroke: 2pt + white,
    image("img/wasm-dump_sample.jpg", height: 1fr),
  ),
)
#template_center(
  upper: [
    == Function セクション
    - id: 3
    - N番目の関数の種類が、Typeセクションで定義されたタイプの\ どれに対応するか指定する
  ],
  box(
    clip: true,
    inset: (top: -173mm, bottom: -251mm, right: -250mm),
    stroke: 2pt + white,
    image("img/wasm-dump_sample.jpg", height: 490mm),
  ),
)
#template_center(
  upper: [
    == Export セクション
    - id: 7
    - エクスポートする（外から使えるようにする）\ 関数などを指定する
    - 外から見える名前も一緒に指定する
  ],
  box(
    clip: true,
    inset: (top: -122mm, bottom: -89mm),
    stroke: 2pt + white,
    image("img/wasm-dump_sample.jpg", width: 100%),
  ),
)
#template_center(
  upper: [
    == Code セクション
    - id: 10 (0x0a)
    - 関数の中身を格納する
  ],
  box(
    clip: true,
    inset: (top: -166mm, bottom: 2mm, right: -100mm),
    stroke: 2pt + white,
    image("img/wasm-dump_sample.jpg", height: 1fr),
  ),
)
#template_center(
  upper: [
    == wasplで見てみよう
    右側のバイナリにカーソルを乗せると詳細を確認できる
  ],
  box(stroke: 2pt + white, image("img/waspl_hover-to-type-section.jpg", width: 100%)),
)
#template_basic[
  == 関数の中身とは？
  #text(fill: green)[*スタックマシン*]にて実行される*命令*のリスト
]
#template_basic[
  == スタックマシン
  #text(fill: green)[*スタック*]と呼ばれる*データ構造*がある
  - 最初に入れた要素が最後に取り出されるような構造
    - このため *FILO* (First-In Last-Out) とも呼ぶ
  - お皿を重ねる様子と同じ
    - 上に乗っているお皿を取り出さないと、\ 一番下にあるお皿を取り出せない
]
// !?
#for i in (0, 1, 2, 3, 3.5, 4, 5) {
  template_two_column(
    [
      == スタックマシンの挙動
      #align(bottom)[
        ```lisp
        (func (result i32)
          i32.const 1
          i32.const 2
          i32.add
          i32.const 0
          i32.mul
        )
        ```
        #if i > 0 {
          place(bottom + left, dx: 10mm, dy: -61.8mm + (int(i) - 1) * 12.5mm, box(
            stroke: 5pt + green,
            width: 59mm,
            height: 13mm,
          ))
        }
      ]
    ],
    align(bottom + center, [
      #block(spacing: 2mm, cetz.canvas({
        import cetz.draw: *
        set-style(
          line: (stroke: 2pt + white),
          rect: (stroke: 1pt + white),
        )
        let w = 4.5
        let h = 8
        line((-w, h), (-w, 0), (w, 0), (w, h))
        let margin = 0.25
        let elem_h = 1.5

        if i >= 1 {
          rect((-w + margin, margin), (rel: (w * 2 - margin * 2, elem_h - margin)), name: "1")
        }
        if 1 <= i and i <= 3 {
          content("1", [1])
        } else if i == 5 {
          content("1", [0])
        } else if i > 3 {
          content("1", [3])
        }

        if (2 <= i and i <= 3) or i == 4 {
          rect(
            (-w + margin, margin + elem_h),
            (rel: (w * 2 - margin * 2, elem_h - margin)),
            name: "2",
          )
          content("2", if i == 4 [0] else [2])
        }
      }))
      スタック
    ]),
  )
}
#template_basic[
  == 関数の中身とは？
  *スタックマシン*にて実行される#text(fill: green)[*命令*]のリスト
  #show grid.cell.where(x: 0): e => strong(e)
  #grid(
    columns: 2,
    column-gutter: 8mm,
    row-gutter: 1.1em,
    [i32.const], [スタックに定数を積む],
    [i32.add/sub/mul/div_u], [スタックから2つ値を取り出して\ 四則演算した結果をスタックに積む],
    [i32.eq], [スタックから2つ値を取り出して\ *同じ値なら1、違う値なら0*を\ スタックに積む],
    [drop], [スタックから値を取り出して、捨てる],
  )
]
#template_center(
  caption: [#link("https://wasm-chart.pengowray.com/")[WebAssembly Opcodes] (非公式)],
  image("img/instruction-table.jpg"),
)
#for i in range(4) {
  template_center(
    upper: [
      == さっきのコードの意味は？
    ],
    [
      ```lisp
      (func (export "sample") (result i32)
        i32.const 12345
      )
      ```
      #set box(stroke: 5pt + green)
      #{
        (
          [],
          [
            #place(top + left, dx: 30mm, dy: 45mm, box(width: 85mm, height: 15mm))
            #place(top + left, dx: 33mm, dy: 30mm)[`"sample"` という名前で関数をエクスポート]
          ],
          [
            #place(top + left, dx: 117mm, dy: 45mm, box(width: 60mm, height: 15mm))
            #place(top + left, dx: 118mm, dy: 30mm)[戻り値はi32 (32bit整数)]
          ],
          [
            #place(top + left, dx: 10mm, dy: 59mm, box(width: 78mm, height: 13mm))
            #place(top + left, dx: 11mm, dy: 89mm)[スタックにi32型の定数 12345 を積む]
          ],
        ).at(i)
      }
    ],
  )
}
#template_basic[
  == 注意
  - Wasmの整数型に*符号付き・符号なしという意味はない*
    - Rustのi32等と異なる
  - Wasmは*命令でこれらを区別する*
    - ある変数を符号付きとして扱いたい場合は\ `_s` (#strong[S]igned) と付く命令を使う
    - 符号なしとして扱いたいなら\ `_u` (#strong[U]nsigned) と付く命令を使う
]
#template_basic[
  == 関数
  - `(result ...)`と書くと、戻り値の型を指定できる
  - 複数の値を返すことも出来る
    - `(result i32 i32)` はi32を2つ返す
  - 関数終了時、*スタックに残っていた値が戻り値*となる
]
#template_center(
  upper: [
    == 関数
    - スタックに残っている値は*戻り値のみでなければならない*
      - 余分な値が残るようなコードを書いてはいけない
    - 本資料では#text(red)[*コンパイルできないコードが登場します*]\ #text(gray, 0.8em)[(スペースに余裕がないため)]
  ],
  caption: [これはだめ（コンパイルエラーになる）],
  [
    ```lisp
    (func (result i32)
      i32.const 0
      i32.const 1
    )
    ```
  ],
)

#template_basic[
  == add関数を作ってみよう
  #quotebox[
    *「引数として数字を 2 つ受け取って、それらを足した数を返す」という関数*を作ってください
  ]\
  → WebAssemblyでやってみよう！
  ```rust
  fn add(lhs: i32, rhs: i32) -> i32 {
    lhs + rhs
  }
  ```
  *`"add"`という名前でエクスポート*しよう
]
#template_basic[
  #show raw: set text(size: 0.84em)
  == 2つの引数を受け取るには？
  - `(param i32 i32)` を使う
  - その後、*`local.get N`*を用いて引数をスタックに積む
    - 1つ目の引数は `local.get 0`で取得（0-indexed）
  ```lisp
  (func $f (param i32 i32) (result i32)
    local.get 0)
  (func (result i32)
    i32.const 100
    i32.const 200
    call $f ;; return 100
  )
  ```
]
#template_basic[
  == こたえ
  次のページにあります（ネタバレ防止）
]
#template_center[
  ```lisp
  (module
    (func (export "add") (param i32 i32) (result i32)
      local.get 0
      local.get 1
      i32.add
    )
  )
  ```
]

#for i in range(2) {
  template_basic[
    #show raw: set text(size: 0.91em)
    == そういえば
    2つの引数を受け取る例：
    ```lisp
    (func $f (param i32 i32) (result i32)
      local.get 0
    )
    (func (result i32)
      i32.const 100
      i32.const 200
      call $f ;; return 100
    )
    ```
    #if i == 1 {
      place(top + left, dx: 26mm, dy: 35mm, box(stroke: 5pt + green, width: 15mm, height: 13mm))
      place(top + left, dx: 9mm, dy: 104mm, box(stroke: 5pt + green, width: 37mm, height: 13mm))
      [しれっと*関数名を定義*していた]
    }
  ]
}
#template_center(
  upper: [== そういえば],
  caption: [Text Formatもあったな],
  [
    #image("img/wasm-spec_top.jpg")
    #place(dx: 74mm, dy: -52.6mm, box(stroke: 3pt + red, width: 20mm, height: 4.5mm))
  ],
)
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [下までスクロールして "Functions"],
  [
    #image("img/wasm-spec_text-fmt.jpg")
    #place(dx: 138mm, dy: -32.5mm, box(stroke: 5pt + red, width: 20mm, height: 6mm))
  ],
)
#template_center(
  upper: [== 仕様書を見てみる],
  image("img/wasm-spec_text-func.jpg"),
)
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [`'(' 'func'`の後に来るもの→idというらしい\ `?` が付いている == 省略可能という意味],
  [
    #box(clip: true, inset: (top: -1mm, bottom: -262mm, right: -45mm), image(
      "img/wasm-spec_text-func.jpg",
      width: 100%,
    ))
    #place(top + left, dx: 65mm, dy: 51.5mm, box(stroke: 5pt + red, width: 59mm, height: 12mm))
  ],
)
#template_center(
  upper: [
    == 仕様書を見てみる
    - `id`はコード内で参照するためのもの
      - あってもなくても出力されるWasmは変わらない
      - export時の名前とは関係がない
    - `?` が付いている == 省略可能という意味
  ],
  [
    #box(
      clip: true,
      inset: (top: -1mm, bottom: -274mm, right: -45mm),
      image(
        "img/wasm-spec_text-func.jpg",
        height: 1fr,
      ),
    )
    #place(top + left, dx: 68mm, dy: 37.5mm, box(stroke: 5pt + red, width: 57mm, height: 12mm))
  ],
)
#template_center(
  upper: [
    == ちなみに
    さっきの`add`の例は……
  ],
  [
    ```lisp
    (module
      (func (export "add") (param i32 i32) (result i32)
        local.get 0
        local.get 1
        i32.add
      )
    )
    ```
  ],
)
#template_center(
  upper: [
    == ちなみに
    こうも書けます
  ],
  [
    ```lisp
    (module
      (func (param i32 i32) (result i32)
        local.get 0
        local.get 1
        i32.add
      )
      (export "add" (func 0))
    )
    ```
  ],
)
#template_basic[
  == どういうことなの
  ```lisp
  (func (export "add") (param i32 i32) (result i32)
    ;; ...
  )
  ```
  ```lisp
  (func (param i32 i32) (result i32)
    ;; ...
  )
  (export "add" (func 0))
  ```
]
#for i in range(2) {
  template_center(
    upper: [== 仕様書を見てみる],
    caption: [Abbreviation（省略）だからそれっぽい],
    [
      #box(clip: true, inset: (top: -151mm, bottom: -37mm), image(
        "img/wasm-spec_text-func.jpg",
        width: 100%,
      ))
      #if i == 0 {
        place(top + left, dy: 6mm, box(stroke: 5pt + red, width: 45mm, height: 10mm))
      } else {
        place(top + left, dx: 36mm, dy: 105mm, box(stroke: 5pt + red, width: 172mm, height: 11mm))
      }
    ],
  )
}
#template_center(
  upper: [
    == ちなみに その2
    さっきの`add`の例は……
  ],
  [
    ```lisp
    (module
      (func (export "add") (param i32 i32) (result i32)
        local.get 0
        local.get 1
        i32.add
      )
    )
    ```
  ],
)
#for i in range(2) {
  template_center(
    upper: [
      == ちなみに その2
      こうも書けます
    ],
    [
      ```lisp
      (module
        (func (export "add")
          (param $lhs i32) (param $rhs i32) (result i32)
          local.get $lhs
          local.get $rhs
          i32.add
        )
      )
      ```
      #if i == 1 {
        place(top + left, dx: 20mm, dy: 32mm, box(stroke: 5pt + green, width: 163mm, height: 14mm))
        place(top + left, dx: 20mm, dy: 58mm, box(stroke: 5pt + green, width: 73mm, height: 12mm))
      }
    ],
  )
}
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [`id` (関数名) より後、`expr` (命令) より前、`local`は使っていない\
    → `typeuse`かな？],
  [
    #box(clip: true, inset: (top: 0mm, bottom: -222mm), image(
      "img/wasm-spec_text-func.jpg",
      width: 100%,
    ))
    #place(top + left, dx: 106mm, dy: 51mm, box(stroke: 5pt + red, width: 44mm, height: 11mm))
  ],
)
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [`(type ...`みたいなやつを書いているわけではないので\ ちょっと違いそう],
  [
    #box(
      clip: true,
      inset: (bottom: -316mm, right: -90mm),
      image("img/wasm-spec_text-typeuse.jpg", width: 100%),
    )
    #place(top + left, dx: 43mm, dy: 64mm, box(stroke: 5pt + red, width: 143mm, height: 11mm))
  ],
)
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [それっぽい（アスタリスク$space.nobreak^*$ 付きなので*繰り返し*書ける）],
  [
    #box(
      clip: true,
      inset: (top: -240mm),
      image("img/wasm-spec_text-typeuse.jpg", width: 100%),
    )
    #place(top + left, dx: 56mm, dy: 60mm, box(stroke: 5pt + red, width: 42mm, height: 10mm))
  ],
)
#template_center(
  upper: [== 仕様書を見てみる],
  caption: [Composit Type かあ],
  [
    #box(
      clip: true,
      inset: (bottom: -42mm),
      image("img/wasm-spec_text-comptype.jpg", width: 100%),
    )
    #place(top + left, dx: 20mm, dy: 81mm, box(stroke: 5pt + red, width: 123mm, height: 10mm))
  ],
)

#template_section("Wasmをブラウザで実行してみよう")
#template_basic[
  == Wasmをブラウザで実行してみよう
  #strong[Web]Assemblyというくらいだからね

  先ほど作成した`add`関数を呼び出してみよう！
]
#template_center(
  upper: [
    == Wasmをブラウザで実行してみよう
    1. wasplからWasmをダウンロード\
    #then[`seccamp26mini-kagosima-wasm/web/public/add.wasm`\  として保存]
  ],
  caption: [WSLだとこんな感じになる],
  image("img/save-add-wasm.jpg", height: 74mm),
)
#template_basic[
  == Wasmをブラウザで実行してみよう
  2. "ターミナルに入力→Enter" を1行ずつやる：
    ```
    cd ~/seccamp26mini-kagosima-wasm/web
    npm install
    npm run dev
    ```
    #lr[※][ターミナルを1度閉じていた場合、最初に\ `wsl -d archlinux` を実行すること]
  3. Google Chromeを開いて、URL欄に\ `localhost:5173` と入力してEnter
]
#template_center(
  upper: [== Wasmをブラウザで実行してみよう],
  caption: [こういうページが見えるはず（数字を入れて計算してみよう）],
  image("img/chrome_exec-add.jpg", width: 80%),
)
#template_basic[
  == Web技術
  Webページは基本的に以下の*3要素*から構成される：
  - *HTML* (HyperText Markup Language)
    - 要素およびその構造を定義する
  - *CSS* (Cascading Style Sheets)
    - HTMLで記述された要素の見た目を変更する
  - *JavaScript*
    - HTML等に動きなどを与える
]
#template_center(
  upper: [
    == 開発者ツールを使ってみよう
    F12キーを押すとこのような画面になる
  ],
  image("img/devtools_first.jpg"),
)
#template_center(
  upper: [
    == 開発者ツールを使ってみよう
    ElementsタブではHTMLやCSSのようすを確認できる
  ],
  caption: [左がHTML、右がCSS],
  box(clip: true, inset: (top: -26mm, left: -245mm, bottom: -75mm), image(
    "img/devtools_first.jpg",
    width: 100%,
  )),
)
#template_center(
  upper: [
    == 開発者ツールを使ってみよう
    - `<body>`の中にある2つの`<section>`のうち\ 上にあるほうの #box(rotate(90deg, polygon.regular(fill: white))) をクリックして展開
    - `<script type="module" src="/src/add.js">` という行の\ `/src/add.js`を右クリックして「Reveal in Sources panel」
  ],
  image("img/devtools_right-click-js.jpg"),
)
#template_center(
  upper: [
    == 開発者ツールを使ってみよう
  ],
  caption: [コードが見える！],
  image("img/devtools_source.jpg"),
)
#template_basic[
  == JavaScriptの実装
  - 変数`instance`を定義
  - `fetch`でダウンロードしたWasmファイルを\ `WebAssembly.instantiateStreaming`に渡して、\ *Wasmモジュール*から*インスタンス*を作成する
  ```js
  let instance = null;
  WebAssembly.instantiateStreaming(
    fetch("/add.wasm")
  ).then((e) => { instance = e.instance; });
  ```
]
#template_basic[
  #show raw: set text(0.87em)
  == JavaScriptの実装
  ID "eq" が与えられたボタンが\ クリックされたときに実行する関数を登録
  ```js
  document.getElementById("eq")?.addEventListener("click", () => {
    // ...
  });
  ```
]
#template_basic[
  #show raw: set text(0.87em)
  == JavaScriptの実装
  - テキストボックスの値を数字に変換
  - 先ほど作ったインスタンスの`exports`に\ エクスポートした関数があるので、実行！
  ```js
  const lhs = document.getElementById("lhs");
  const lhs_number = Number(lhs?.value);
  const rhs = document.getElementById("rhs");
  const rhs_number = Number(rhs.value);
  return instance?.exports.add(lhs_number, rhs_number);
  ```
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  - 画像は#underline[赤、緑、青 (RGB) の3要素]により構築される
  - *#text(fill: green)[RGB値3つ]を引数として受け取り*、加工をするなどして、\
    *#text(fill: green)[RGB値3つ]を戻り値として返す関数*を作ろう
  - 作った関数は *`"filter"` と名付けてエクスポート*する
  - Wasmファイルを以下のように保存：\ `seccamp26mini-kagosima-wasm/web/public/filter.wasm`
  - 「フィルタ」ボタンを押すと、フィルタ処理が実行される
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  関数の定義はどうなる？

  （答えは次のページ）
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  ```lisp
  (module
    (func (export "filter")
      (param i32 i32 i32)
      (result i32 i32 i32)
      local.get 0 ;; R値
    )
  )
  ```
]
#template_basic[
  #show raw: set text(0.98em)
  == 演習：Wasmで画像を加工しよう
  こう書くと引数の意味がわかりやすくなる
  ```lisp
  (module
    (func (export "filter")
      (param $r i32)
      (param $g i32)
      (param $b i32)
      (result i32 i32 i32)
      local.get $r ;; R値
    )
  )
  ```
  #place(top + left, dx: 20mm, dy: 59mm, box(stroke: 5pt + green, height: 39mm, width: 70mm))
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  例えば、画像全体を緑（`#00FF00`）にするには？

  （答えは次のページ）
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  例えば、画像全体を緑（`#00FF00`）にするには？
  ```lisp
  (module
    (func (export "filter")
      (param i32 i32 i32) (result i32 i32 i32)
      i32.const 0   ;; R
      i32.const 255 ;; G
      i32.const 0   ;; B
    )
  )
  ```
]
#template_center(
  upper: [== 演習：Wasmで画像を加工しよう],
  caption: [実行したときのようす],
  image("img/chrome_exec-green-filter.jpg"),
)
#template_basic[
  == 演習：Wasmで画像を加工しよう
  アイデアリスト：
  - グレースケール化
  - 色反転
  - RGBを入れ替えてみる
  - *(発展)* 右のピクセルほど明るくなる……？
    - Wasmの関数を呼び出す部分を変える必要がある
]
#template_basic[
  == 演習：Wasmで画像を加工しよう
  使えそうな命令
  #columns(2)[

    - 足し算 : *i32.add*
    - 引き算 : *i32.sub*
    - 掛け算 : *i32.mul*
    - 割り算 : *i32.div_u*
    - `==` : *i32.eq*
    - `!=` : *i32.ne*
    #colbreak()
    - $<= space$ : *i32.le\_u*
    - $< space$ : *i32.lt\_u*
    - $>= space$ : *i32.ge\_u*
    - $> space$ : *i32.gt\_u*
      - #strong[L]ess/#strong[G]reat+#strong[E]qual/#strong[T]han\ + #strong[U]nsigned
      - #text(0.8em)[今回は負の値を扱わない]
  ]
]
#template_basic[
  #show raw: set text(size: 0.87em)
  == 演習：Wasmで画像を加工しよう
  ローカル変数を用いるスタック複製
  ```lisp
  (func (export "filter") (param i32 i32 i32) (result i32 i32 i32)
    (local i32)      ;; ローカル変数は result の後に宣言
    local.get 0      ;; R値
    local.get 1      ;; G値
    local.get 2      ;; B値
    local.get 3      ;; ローカル変数
    i32.const 128
    local.tee 3
    ;; local[3] に128が格納される+スタック最上部に128が残る
  )
  ```
]
#template_basic[
  #show raw: set text(size: 0.8em)
  == 演習：Wasmで画像を加工しよう
  if文
  ```lisp
  (func (export "filter")
    (param i32 i32 i32) (result i32 i32 i32)
    local.get 0      ;; R値
    i32.const 128
    i32.lt_s         ;; R < 128 なら1がスタックに積まれる
    if (result i32)
      i32.const 0    ;; R < 128なら黒にする
    else
      i32.const 255  ;; R >= 128 なら赤
    end
  )
  ```
  #place(top + left, dx: 8mm, dy: 87mm, box(width: 63mm, height: 50mm, stroke: 3pt + green))
]

#template_basic[
  == おわりに
  - WebAssemblyのテキスト形式 / バイナリ形式を見てきた
    - Wasmバイナリは*セクション*という単位によって構成される
    - Codeセクションに格納されている命令を\ *スタックマシン*により実行する
  - 今回は一部しか見せられなかったが、\ Wasmが持つ機能や命令は豊富
    - ぜひためしてみてね
]

#template_center[= 補足]
#template_basic[
  == next step（時間が余ったらやりたいこと）
  - Wasm instantiate時のimportObject
  - 説明していないセクション
    - *import*, *memory*, global, ...
  - DevToolsのPerformanceタブで計測
  - WASI & Component Model
  - `file /usr/bin/ls`に出てきたELFって何
]
#template_basic[
  == 余談：「バージョンの違い」とは？
  マジックナンバー直後が`0d 00 01 00`になっていたのは\
  `rustc --target wasm32-wasip2 add.rs`として生成したWasm
  #then[WASI (Component Model) 用にビルドされている]

  #show raw: set text(0.91em)
  cf. #link("https://github.com/WebAssembly/component-model/blob/main/design/mvp/Binary.md#component-definitions")[Binary.md]
  ```
  component ::= <preamble> s*:<section>*            => (component flatten(s*))
  preamble  ::= <magic> <version> <layer>
  magic     ::= 0x00 0x61 0x73 0x6D
  version   ::= 0x0d 0x00
  layer     ::= 0x01 0x00
  ```
]
