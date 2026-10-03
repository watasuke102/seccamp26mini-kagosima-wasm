# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "matplotlib>=3.8",
# ]
# ///
import matplotlib.pyplot as plt

BG = "#282c34"
FG = "#abb2bf"
PALETTE = ["#e06c75", "#98c379", "#e5c07b", "#61afef", "#c678dd", "#56b6c2", "#d19a66"]

data: dict[str, float] = {
    "C": 3,
    "C++": 3,
    "Rust": 2,
    "Python": 2,
    "Go": 1,
    "Java": 1,
}

def make_pie_chart(values: dict[str, float], output: str = "img/pre-assignment-languages.pdf") -> None:
    plt.rcParams["font.family"] = "Rounded M+ 1c"
    fig, ax = plt.subplots(figsize=(6, 6), facecolor=BG)
    ax.set_facecolor(BG)
    _, _, autotexts = ax.pie(
        values.values(),
        labels=values.keys(),
        autopct="%1.1f%%",
        startangle=90,
        counterclock=False,
        colors=PALETTE,
        wedgeprops={"edgecolor": BG, "linewidth": 2},
        textprops={"color": FG, "fontsize": 17},
     )
    for autotext in autotexts:
        autotext.set_color(BG)
    ax.set_title("事前課題にて使われた言語の割合", color=FG, pad=20, fontsize=21, fontweight="bold")
    ax.axis("equal")
    fig.savefig(output, dpi=150, bbox_inches="tight", facecolor=BG)
    print(f"Saved: {output}")

if __name__ == "__main__":
    make_pie_chart(data)
