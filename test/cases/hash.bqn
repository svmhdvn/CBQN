# some checks for behavior around ¯0; not strictly necessary to stay, but other tests will probably become meaningless without these!
1⊏64‿1•bit._cast ≍˘ •ParseFloat¨ "1.2"‿"-0" %% 63‿1/0‿1
! (4⥊0) (≡ ∧ ≢○(64‿1•bit._cast⊢)) 1↓¯1×π∾4⥊0
! ≢˝64‿1•bit._cast ≍˘0‿5⊏⥊(¯1⊸×≍⊢) (↕3)∾∞∾0÷0

# ¯0
! ≡´ {•Hash •ParseFloat¨ 𝕩‿"1.2"}¨ "0"‿"-0"
! 1‿0 ≡ ∊{•ParseFloat¨ 𝕩‿"1.2"}¨ "0"‿"-0"
a←(•ParseFloat¨ "1.2"‿"-0"‿"0")∾-⊸⋈0÷0 ⋄ ∊1•Hash¨ a %% 1‿1‿0‿1‿0
a←(•ParseFloat¨ "1.2"‿"-0"‿"0")∾-⊸⋈0÷0 ⋄ b←0+--a ⋄ ! a •internal.EEqual b ⋄ ! a ≡○(3⊸↑) b ⋄ ! 0≡a •Cmp b ⋄ ! a ≡○(1⊸•Hash¨) b ⋄ ! a ≡○(1⊸•Hash) b
a←(•ParseFloat¨ "1.2"‿"-0"‿"0")∾-⊸⋈0÷0 ⋄ ! (0‿3‿3‿3⊏a) ≡○•Hash (0‿4‿4‿4⊏a)

# functions
⍷⟨⊢⊢⊢, ⊢⊢⊢, +⊢⊢, ⊢+⊢, ⊢⊢+, ⊢⊢, ⊢⊢, ⊢+, 1⊸+, 1⊸+, 2⊸+, 1⟜+, 1⊸×, ⊢+⊢, ⊢⊢⊢, +⊢⊢, +˘, ×˘, +˘, +˝⟩ %% ⟨⊢⊢⊢, +⊢⊢, ⊢+⊢, ⊢⊢+, ⊢⊢, ⊢+, 1⊸+, 2⊸+, 1⟜+, 1⊸×, +˘, ×˘, +˝⟩

# various
[1‿1, 0‿1, 1‿0, 0‿0, 1‿1, 0‿0] ∊ [0‿0, 0‿1, 1‿0] %% 0‿1‿1‿1‿0‿1
[[0‿0, 0‿1, 1‿0, 1‿1], [1‿1, 0‿1, 1‿0, 0‿0]] ∊ [0‿0, 0‿1, 1‿0] %% 2‿4⥊1‿1‿1‿0‿0‿1‿1‿1
[1‿1, 0‿1, 1‿0, 0‿0, 1‿1, 0‿0] ∊○(≍⎉0) [0‿0, 0‿1, 1‿0] %% 0‿1‿1‿1‿0‿1
[[0‿0, 0‿1, 1‿0, 1‿1], [1‿1, 0‿1, 1‿0, 0‿0]] ∊○(≍⎉0) [0‿0, 0‿1, 1‿0] %% 2‿4⥊1‿1‿1‿0‿0‿1‿1‿1
⊐˜∾˜"ihxtIddKLp"‿'r'‿÷‿"EXiRowcDXx"‿'a'‿"ZNtqFbDCYZ"‿⍒‿0.05369125494326554‿↑‿5 %% ∾˜↕10
0‿1∊˜⟨"ab","cd"⟩ %% 0‿0
0‿1⊐ ⟨"ab","cd"⟩ %% 2‿2
(<"ab")∊"ab"‿"cd" %% <1
(<"cd")∊"ab"‿"cd" %% <1
(<"ef")∊"ab"‿"cd" %% <0
(127⥊"abc")⊐"abcd" %% 0‿1‿2‿127
(128⥊"abc")⊐"abcd" %% 0‿1‿2‿128
(32767⥊"abc")⊐"abcd" %% 0‿1‿2‿32767
(32768⥊"abc")⊐"abcd" %% 0‿1‿2‿32768
(127⥊"abc")⊐100⥊"ababacadabacaba" %% (100⥊0‿1‿0‿1‿0‿2‿0‿  127‿0‿1‿0‿2‿0‿1‿0)
(128⥊"abc")⊐100⥊"ababacadabacaba" %% (100⥊0‿1‿0‿1‿0‿2‿0‿  128‿0‿1‿0‿2‿0‿1‿0)
(32767⥊"abc")⊐100⥊"ababacadabacaba" %% (100⥊0‿1‿0‿1‿0‿2‿0‿32767‿0‿1‿0‿2‿0‿1‿0)
(32768⥊"abc")⊐100⥊"ababacadabacaba" %% (100⥊0‿1‿0‿1‿0‿2‿0‿32768‿0‿1‿0‿2‿0‿1‿0)
⍷ •internal.Variation⟜(↕1)¨ "Ab"‿"Ai8" %% ⟨⋈0⟩
!∘≡¨⟜⊏ 0•Hash¨ ⟨↕5 ⋄ 1↓0.5∾↕5 ⋄ 1↓'h'∾↕5⟩

{b←•internal.Unshare a←"Ai8"•internal.Variation ∾⟨16⥊0‿0‿0‿0‿0‿0‿0‿¯128, 8⥊0, 8↑2⟩ ⋄ c←8‿64•bit._cast a ⋄ ! 1‿0‿0‿1≡∊c ⋄ •internal.Keep •Hash c ⋄ ! a≡b} # make sure sign bit doesn't mutate away

# error messages
!"𝕨∊𝕩: 𝕩 cannot have rank 0" % 1‿2‿3∊0
!"𝕨⊐𝕩: 𝕨 cannot have rank 0" % 0⊐1‿2‿3
!"𝕨⊒𝕩: 𝕨 cannot have rank 0" % 0⊒1‿2‿3
!"𝕨∊𝕩: Rank of 𝕨 must be at least the cell rank of 𝕩 (⟨2⟩ ≡ ≢𝕨, 2‿2‿2 ≡ ≢𝕩)" % 1‿2∊2‿2‿2⥊1‿2
!"𝕨⊐𝕩: Rank of 𝕩 must be at least the cell rank of 𝕨 (2‿2‿2 ≡ ≢𝕨, ⟨2⟩ ≡ ≢𝕩)" % (2‿2‿2⥊1‿2)⊐1‿2
!"𝕨⊒𝕩: Rank of 𝕩 must be at least the cell rank of 𝕨 (2‿2‿2 ≡ ≢𝕨, ⟨2⟩ ≡ ≢𝕩)" % (2‿2‿2⥊1‿2)⊒1‿2

# hashmap
("abc"‿"de"‿"fgh" •HashMap ⥊¨↕3).Get "fgh" %% ⟨2⟩
∞ ("abc"‿"de"‿"fgh" •HashMap ⥊¨↕3).Get "fghi" %% ∞
("abc"‿"de"‿"fgh" •HashMap ⥊¨↕3).Count"xy" %% 3
("b" ("a"‿"b" •HashMap "A"‿"C").Set "B").Get "b" %% "B"
((•HashMap˜↕4).Set´ 1‿"one").Keys↕2 %% ↕4
(((•HashMap˜↕4).Delete 1).Set´ 1‿"one").Keys@ %% 0‿2‿3‿1
(((•HashMap˜↕4).Delete 1).Set´ 1‿"one").Values@ %% 0‿2‿3‿"one"
({𝕩.Set´"xy"}⍟4•HashMap˜↕0).Count@ %% 1
!"𝕨 •HashMap 𝕩: Arguments must be lists (⟨⟩≡≢𝕨, ⟨3⟩≡≢𝕩)" % 'a' •HashMap "str"
!"𝕨 •HashMap 𝕩: 𝕨 and 𝕩 must have the same length (4≡≠𝕨, 3≡≠𝕩)" % "stri" •HashMap "str"
!"•HashMap: 𝕨 contained duplicate keys" % "strs" •HashMap "stri"
!"(hashmap).Get: key not found" % ("abc"‿"de"‿"fgh" •HashMap ⥊¨↕3).Get "fg"
!"(hashmap).Delete: key not found" % ("abc"‿"de"‿"fgh" •HashMap ⥊¨↕3).Delete 'a'
m ← 1‿2 •HashMap v←•internal.Unshare 'a'‿4 ⋄ 1 m.Set 9 ⋄ ⟨v, m.Keys@, m.Values@⟩ %% ⟨'a'‿4, 1‿2, 9‿4⟩
m ← 1‿2 •HashMap •internal.Unshare 'a'‿4 ⋄ v←m.Values@ ⋄ 1 m.Set 9 ⋄ ⟨v, m.Keys@, m.Values@⟩ %% ⟨'a'‿4, 1‿2, 9‿4⟩
