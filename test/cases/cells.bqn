%DEF var V←•internal.Variation ⋄ LV←•internal.ListVariations ⋄ CLR←•internal.ClearRefs
%DEF tvar %USE var ⋄ _tvar ← {F _𝕣 x: (CLR@) ⊢ {F 𝕩 V x}¨ LV 𝕩; w F _𝕣 x: (CLR@) ⊢ (LV 𝕨) {(𝕨 V w) F 𝕩 V x}⌜ LV 𝕩}
%DEF eqvar %USE tvar ⋄ _eqvar ← {r ← 𝕨 𝔽 _tvar 𝕩 ⋄ !∘≡⟜(⊑r)¨ r ⋄ ⊑r}
%DEF evar %USE tvar ⋄ _evar ← {ok←{⇐} ⋄ r←⥊𝕨 ok∘𝔽⎊{𝕊: •CurrentError@} _tvar 𝕩 ⋄ {⊑ok∊r? !"TEST FAIL: variation didn't error"; ("TEST FAIL: varying error messages"⊸⋈ ! 1=≠)⍷r ⋄ !⊑r}}
%DEF eqerr %USE eqvar ⋄ _eqerr ← {ok←{⇐} ⋄ r←⥊𝕨 ok∘𝔽⎊{𝕊: •CurrentError@}⌜ 𝕩 ⋄ {⊑ok∊r? !"TEST FAIL: case didn't error"; ("TEST FAIL: varying error messages"⊸⋈ ! 1=≠)⍷r ⋄ !⊑r}}
%DEF k _k ← {𝔽○•internal.Keep}
%DEF pk _pk ← {𝔽○•internal.PureKeep}

1‿2 1⎉0 1 %% 1‿1
1 1⎉0 1‿2 %% 1‿1
! 20‿1200≡≢⥊˘a←20‿30‿40⥊↕24 ⋄ ! 20‿30‿40 ≡ ≢a
! (2⊸-⎉1 ≡ {2-𝕩}⎉1) 10‿10⥊↕100
! (-⟜2⎉1 ≡ {𝕩-2}⎉1) 10‿10⥊↕100
%USE k ⋄ n←1 ⋄ ≠{𝕊: (•Repr a) ! (≡⎉n ≡ ≡_k⎉n)´ a←(⊏⟜(3‿2‿2⥊'a'+↕26))¨ <˘ 2‿2‿2‿2•rand.Range 3}¨ ↕1000
%USE k ⋄ n←2 ⋄ ≠{𝕊: (•Repr a) ! (≡⎉n ≡ ≡_k⎉n)´ a←(⊏⟜(3‿2‿2⥊'a'+↕26))¨ <˘ 2‿2‿2‿2•rand.Range 3}¨ ↕1000
%USE k ⋄ n←3 ⋄ ≠{𝕊: (•Repr a) ! (≡⎉n ≡ ≡_k⎉n)´ a←(⊏⟜(3‿2‿2⥊'a'+↕26))¨ <˘ 2‿2‿2‿2•rand.Range 3}¨ ↕1000
≠{𝕊k: ! (3⊸↑⎉k ≡ {3↑𝕩}⎉k) 2‿2‿2‿2⥊↕16}¨ ¯2+↕10
≠{𝕊k: ! (1⊸↓⎉k ≡ {1↓𝕩}⎉k) 3‿3‿3‿3⥊↕81}¨ ¯2+↕10

!"˘: Result rank too large" % (0∾254⥊2)⊸⥊∘1˘ 0‿2⥊1
!"⎉: Result rank too large" % (0∾254⥊2)⊸⥊∘1⎉¯1 0‿2⥊1
!"⎉: Result rank too large" % (1⥊˜ 0∾204⥊2)⎉50 1⥊˜ 0∾100⥊2
!"𝔽⎉𝕘: Result rank too large (204 ≡ =𝕩, 200 ≡ =𝔽v)" % {𝕊:(200⥊1)⥊1}⎉1 (205⥊1)⥊1

!"𝕨⎉𝕩: Argument frames don't agree (⟨3⟩ ≡ ≢𝕨, ⟨2⟩ ≡ ≢𝕩, common frame of 1 axes)" % "abc" ⊢⎉0 "ab"
!"𝕨˘𝕩: Argument frames don't agree (⟨3⟩ ≡ ≢𝕨, ⟨2⟩ ≡ ≢𝕩, common frame of 1 axes)" % "abc" ⊢˘ "ab"
! ∧´{𝕊: ! (∾≡{𝕨∾𝕩}´) (<•rand.Range∘≠⊸⊑ ⟨"ab",1‿2,⟨⟩,↕0,""⟩) ∾˜ (4•rand.Range≠)⊸⊏ ⟨1, {⇐}, 'a', <'a', <{⇐}, "ab", ↕0, ""⟩}¨↕10000

# error cases that could be affected by special code
!"∧𝕩: 𝕩 cannot have rank 0" % ∧˘↕2
!"∨𝕩: 𝕩 cannot have rank 0" % ∨˘"a"
!"Expected non-negative integer, got ¯3" % 2‿¯3/⎉1 6‿2⥊0
!"𝕨/𝕩: Lengths of components of 𝕨 must match 𝕩 (3 ≠ 4)" % 1‿2‿3⊸/˘≍4‿5‿6‿7
!"𝕨/𝕩: Simple 𝕨 must have rank 0 or 1 (2≡=𝕨)" % (2‿3‿1⥊↕4) /˘ ↕2
!"𝕨/𝕩: Length of compound 𝕨 must be at most rank of 𝕩" % (<↕0)/˘○(5⊸⥊)<"ab"
!"𝕨⊏𝕩: Indexing out-of-bounds (24∊𝕨, 4≡≠𝕩)" % 1‿24⊏⎉1↕4‿4
!"𝕨⊏𝕩: Indexing out-of-bounds (4∊𝕨, 4≡≠𝕩)" % ⊏⎉1˜6‿4⥊↕24
!"𝕨⊏𝕩: 𝕨 must be an array of numbers or list of such arrays" % 0‿@‿¯1⊏⎉1 5‿2⥊0.5
!"Expected integer, got ¯5.25" % ¯5.25⊏˘∘‿4⥊↕24
!"𝕨⊏𝕩: Indexing out-of-bounds (1∊𝕨, 1≡≠𝕩)" % 0‿0‿1 ⊏˘○(≍˘) 10000×↕3
!"𝕨⊏𝕩: 𝕩 cannot be a unit" % 0⊏˘5⥊<"a"
!"𝕨⊏𝕩: 𝕩 cannot be a unit" % (3‿0⥊⟨⟩)⊏˘↕3
!"Expected integer, got 0.1" % 0.1⊑˘3‿5⥊↕15
!"𝕨⊑𝕩: 𝕩 must be a list when 𝕨 is a number (3‿4 ≡ ≢𝕩)" % 5⊑˘↕2‿3‿4
!">𝕩: Result rank too large (80 ≡ =𝕩, 205 ≡ =⊑𝕩)" % >⎉80 (200⥊1)⥊<(205⥊1)⥊1
!"𝔽⎉𝕘: Result rank too large (195 ≡ =𝕩, 210 ≡ =𝔽v)" % >⎉5 (200⥊1)⥊<(205⥊1)⥊1
!"𝕨∾𝕩: Lengths not matchable (⟨6⟩ ≡ ≢𝕨, 1‿1 ≡ ≢𝕩)" % ("abc"∾"def")∾˘○(3/≍)≍"a"
!"𝕨∾𝕩: Argument ranks must differ by 1 or less (0≡=𝕨, 2≡=𝕩)" % 1∾˘↕3‿3‿3
!"𝕨∾𝕩: Lengths not matchable (4‿2 ≡ ≢𝕨, 3‿3 ≡ ≢𝕩)" % (3‿4‿2⥊4)∾˘3‿3‿3⥊5
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (3‿4 ≡ ≢𝕨, 3‿3 ≡ ≢𝕩)" % (↕3‿4)≍⎉2 2‿3‿3⥊↕18
!"≍𝕩: Result rank too large (255≡=𝕩)" % ≍⎉∞ 0⥊˜255⥊1
!"shift: Lengths not matchable (⟨6⟩ ≡ ≢𝕨, 1‿1 ≡ ≢𝕩)" % ("abc"∾"def")«˘○(3/≍)≍"a"
!"shift: =𝕨 must be =𝕩 or ¯1+=𝕩 (0≡=𝕨, 2≡=𝕩)" % 1«˘↕2‿2‿2
!"»𝕩: 𝕩 cannot be a scalar" % »⎉0 2‿3‿1⥊↕6
!"⌽𝕩: 𝕩 cannot be a unit" % ⌽˘↕10
!"Expected integer, got 1.5" % 1.5↑˘↕2‿3‿2
!"𝕨↑𝕩: 𝕨 must have rank at most 1 (1‿2 ≡ ≢𝕨)" % (≍1‿2)⊸↑˘↕2‿3‿2
!"𝕨↓𝕩: 𝕨 must have rank at most 1 (4‿2 ≡ ≢𝕨)" % (4‿2⥊↕8)↓˘○≍@
!"Integer out of range: 1e20" % 1e20⌽˘3‿10⥊10
!"Expected number" % 3‿4‿@⌽˘↕3‿4
!"Expected integer, got 0.5" % 0.5⊸⌽˘4‿3⥊↕12
!"↑𝕩: 𝕩 must have rank at least 1" % ↑˘↕2
!"↓𝕩: 𝕩 must have rank at least 1" % ↓⎉0 2‿1⥊0
!"⊐𝕩: 𝕩 cannot have rank 0" % ⊐˘"abcd"
!"⊒𝕩: 𝕩 cannot have rank 0" % ⊒˘"abcd"
!"∊𝕩: 𝕩 cannot have rank 0" % ∊˘"abcd"
!"𝕨⍋𝕩: 𝕨 must be sorted" % 0‿2‿1⊸⍋˘ 3‿4⥊↕12
!"𝕨𝔽`𝕩: Shape of 𝕨 must match the cell of 𝕩 (⟨2⟩ ≡ ≢𝕨, 2‿3 ≡ ≢𝕩)" % (2‿2⥊1)+`˘2‿2‿3⥊0.4
!"𝕨𝔽`𝕩: Shape of 𝕨 must match the cell of 𝕩 (⟨⟩ ≡ ≢𝕨, 3‿3 ≡ ≢𝕩)" % 2+`˘↕3‿3‿3
!"𝔽´𝕩: 𝕩 must be a list (3‿3 ≡ ≢𝕩)" % +´˘2‿3‿3⥊↕18
!"𝕨𝔽´𝕩: 𝕩 must be a list (3‿3 ≡ ≢𝕩)" % 1+´˘2‿3‿3⥊↕18
!"𝔽˝𝕩: 𝕩 must have rank at least 1" % +˝˘˘10‿10⥊↕100
!"𝔽˝𝕩: 𝕩 must have rank at least 1" % ∾˝⎉¯2 2‿3⥊9

{∾˝˘ ⥊⟜(↕×´) 2+↕𝕩}¨ 2‿3‿4‿5 %% ⥊⟜(↕×´)¨   ⟨2‿3,2‿12,2‿12‿5,2‿12‿5‿6⟩
{∾˝˘ (2+↕𝕩)⥊<"hi"}¨ 2‿3‿4‿5 %% ⥊⟜(<"hi")¨ ⟨2‿3,2‿12,2‿12‿5,2‿12‿5‿6⟩
{∾˝⎉¯2 ⥊⟜(↕×´) 2+↕𝕩}¨ 3‿4‿5 %% ⥊⟜(↕×´)¨ ⟨2‿3‿4,2‿3‿20,2‿3‿20‿6⟩

%DEF tcc %USE pk ⋄ %USE var ⋄ _tcc_ ← { ! ∧´ (<𝕨 𝔽_pk⎉𝕘⎊'e' 𝕩) ≡¨ (𝕨 𝔽⎉𝕘⎊'e'V⟜𝕩)¨ "i"LV𝕩}
%USE tcc ⋄ ⟨2, 20, ¯2, ¯20, 0⟩ {𝕨 ↑_tcc_ ¯1 𝕩 ⋄ 𝕨 ↓_tcc_ ¯1 𝕩}⌜ ⟨<4, ↕5, 4‿5⥊↕20, 4‿5‿6⥊↕120⟩
%USE tcc ⋄ ⟨⌽, ⍉, ⊏, <, ≍, ⥊, (↕0)⊸⊏, (↕1)⊸⊏, (↕2)⊸⊏⟩ {𝕎 _tcc_ ¯1 𝕩 ⋄ 𝕎 _tcc_ 1 𝕩 ⋄ 𝕎 _tcc_ 2 𝕩}⌜ ⟨<4, ↕5, 4‿5⥊↕20, 4‿5‿6⥊↕120, 2‿3‿4‿5⥊↕120, 10‿0⥊0, 0‿10⥊0, 0‿2‿3⥊0, 2‿3‿4‿0⥊0⟩
%USE tcc ⋄ ⊏_tcc_ ¯1 4‿2⥊↕8 ⋄ 1⊏_tcc_ ¯1 4‿2⥊↕8 ⋄ ⊏_tcc_ ¯1 ↕4‿2 ⋄ 1⊏_tcc_ ¯1 ↕4‿2
%USE tcc ⋄ ⊑_tcc_ ¯1 4‿2⥊↕8 ⋄ 1⊑_tcc_ ¯1 4‿2⥊↕8 ⋄ ⊑_tcc_ ¯1 ↕4‿2 ⋄ 1⊑_tcc_ ¯1 ↕4‿2

%USE eqvar ⋄ 0‿0‿0‿0 {𝕨⊸⊏˘𝕩}_eqvar ≍˘↕5 %% 5‿4⥊⌊4÷˜↕20
%USE eqvar ⋄ 0‿¯1‿0‿¯1 {𝕨⊸⊏˘𝕩}_eqvar ≍˘↕5 %% 5‿4⥊⌊4÷˜↕20
%USE eqvar ⋄ 100‿¯3 {𝕨⊸⊏˘𝕩}_eqvar 10‿200⥊↕2000 %% 10‿2⥊100‿197‿300‿397‿500‿597‿700‿797‿900‿997‿1100‿1197‿1300‿1397‿1500‿1597‿1700‿1797‿1900‿1997
%USE eqvar ⋄ 100‿50 {𝕨⊸⊏˘𝕩}_eqvar 10‿200⥊↕2000 %% 10‿2⥊100‿50‿300‿250‿500‿450‿700‿650‿900‿850‿1100‿1050‿1300‿1250‿1500‿1450‿1700‿1650‿1900‿1850
%USE eqvar ⋄ ¯1‿¯2‿¯3 {𝕨⊸⊏˘𝕩}_eqvar 8‿80⥊↕557 %% 8‿3⥊79‿78‿77‿159‿158‿157‿239‿238‿237‿319‿318‿317‿399‿398‿397‿479‿478‿477‿2‿1‿0‿82‿81‿80
1‿2‿0‿1‿¯1⊸⊏⎉1 2‿3‿4⥊↕24 %% 2‿3‿5⥊1‿2‿0‿1‿3‿5‿6‿4‿5‿7‿9‿10‿8‿9‿11‿13‿14‿12‿13‿15‿17‿18‿16‿17‿19‿21‿22‿20‿21‿23
1‿2‿0‿1‿¯1⊸⊏⎉2 2‿3‿4⥊↕24 %% 2‿5‿4⥊4‿5‿6‿7‿8‿9‿10‿11‿0‿1‿2‿3‿4‿5‿6‿7‿8‿9‿10‿11‿16‿17‿18‿19‿20‿21‿22‿23‿12‿13‿14‿15‿16‿17‿18‿19‿20‿21‿22‿23
!"𝕨⊏𝕩: Indexing out-of-bounds (1∊𝕨, 1≡≠𝕩)" % %USE evar ⋄ 0‿¯1‿1‿¯1 {𝕨⊸⊏˘𝕩}_evar ≍˘↕5
!"𝕨⊏𝕩: Indexing out-of-bounds (¯2∊𝕨, 1≡≠𝕩)" % %USE evar ⋄ 0‿¯1‿¯2‿¯1 {𝕨⊸⊏˘𝕩}_evar ≍˘↕5
!"𝕨⊏𝕩: Indexing out-of-bounds (¯129∊𝕨, 128≡≠𝕩)" % %USE evar ⋄ 10‿¯129 {𝕨⊸⊏˘𝕩}_evar 10‿128⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (128∊𝕨, 128≡≠𝕩)" % %USE evar ⋄ 10‿128 {𝕨⊸⊏˘𝕩}_evar 10‿128⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (1∊𝕨, 1≡≠𝕩)" % %USE evar ⋄ 1‿0‿0‿1 {𝕨⊸⊏˘𝕩}_evar 10‿1⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (1000∊𝕨, 3≡≠𝕩)" % %USE evar ⋄ (3⥊1000) {𝕨⊸⊏˘𝕩}_evar 100‿3⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (1000∊𝕨, 4≡≠𝕩)" % %USE evar ⋄ (4⥊1000) {𝕨⊸⊏˘𝕩}_evar 100‿4⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (1000∊𝕨, 8≡≠𝕩)" % %USE evar ⋄ (8⥊1000) {𝕨⊸⊏˘𝕩}_evar 100‿8⥊1
!"𝕨⊏𝕩: Indexing out-of-bounds (100∊𝕨, 8≡≠𝕩)" % %USE evar ⋄ (<100) {𝕨⊸⊏˘𝕩}_evar 100‿8⥊1
!"Integer out of range: 9e99" % %USE evar ⋄ (<9e99) {𝕨⊸⊏˘𝕩}_evar 100‿8⥊1
⟨1‿2⟩⊸⊏˘ 10‿8⥊↕100 %% (8×↕10) +⌜ 1‿2
⟨1‿2⟩⊸⊏˘ 10‿4‿2⥊↕100 %% (8×↕10) +⌜ [2‿3,4‿5]
⟨1‿2,⟨1,0⟩⟩⊸⊏˘ 10‿4‿2⥊↕100 %% (8×↕10) +⌜ [3‿2,5‿4]
[2‿1,4‿5]⊸⊏˘ 10‿8⥊↕100 %% (8×↕10) +⌜ [2‿1,4‿5]
[1‿1,0‿1]⊸⊏˘ 10‿2‿2⥊↕100 %% (4×↕10) +⌜ 2‿2‿2⥊2‿3‿2‿3‿0‿1‿2‿3
%USE eqvar ⋄ [2‿1‿3,4‿5‿7] {𝕨⊸⊏˘ 𝕩}_eqvar 10‿8⥊↕100 %% (8×↕10) +⌜ [2‿1‿3,4‿5‿7]
%USE eqvar ⋄ [2‿1‿3,4‿5‿7] {𝕨⊸⊏⎉1𝕩}_eqvar 3‿4‿8⥊↕100 %% (3‿4⥊8×↕12) +⌜ [2‿1‿3,4‿5‿7]
%USE eqvar ⋄ [2‿1‿3,4‿5‿7] {𝕨⊸⊏˘ 𝕩}_eqvar 1‿8⥊↕100 %% ≍[2‿1‿3,4‿5‿7]
%USE eqvar ⋄ (<2) {𝕨⊸⊏˘𝕩}_eqvar 10‿8⥊↕100 %% 2 + 8×↕10

≍⁼˘ 10‿1⥊↕10 %% ↕10
≍⁼˘ 10‿1‿3⥊↕30 %% 10‿3⥊↕30
≍⁼˘ 10‿1‿3‿2⥊↕60 %% 10‿3‿2⥊↕60
≍⁼⎉¯2 4‿2‿1⥊↕8 %% 4‿2⥊↕8
≍⁼⎉¯2 4‿2‿1‿3⥊↕24 %% 4‿2‿3⥊↕24
≍⁼⎉¯2 4‿2‿1‿3‿2⥊↕48 %% 4‿2‿3‿2⥊↕48
≍⁼⎉1 ⋈"foo" %% <"foo"
≍⁼⎉1 ⋈10 %% <10
!"≍⁼𝕩: Argument must have a leading axis of 1" % ≍⁼˘ 1‿10⥊2
!"≍⁼𝕩: Argument must have a leading axis of 1" % ≍⁼⎉¯2 1‿1‿2‿1‿1⥊1
!"≍⁼𝕩: Argument must have a leading axis of 1" % ≍⁼⎉¯2 1‿1⥊10
!"≍⁼𝕩: Argument must have a leading axis of 1" % ≍⁼⎉0 ⋈10

%USE eqvar ⋄ (100⥊5↑1) ≍˘_eqvar 100⥊7↑1 %% 0=(↕100) |˜⌜ 5‿7
%USE eqvar ⋄ ('a'+100⥊↕5) ≍˘_eqvar 100⥊↕7 %% 'a'‿0 +⎉1 (↕100) |˜⌜ 5‿7
%USE eqvar ⋄   1⊸(≍˘)_eqvar 100⥊7↑1 %% 100‿2⥊ (    ¬2|↕200) ⌈ 2/0=7|↕100
%USE eqvar ⋄ 1e9⊸(≍˘)_eqvar 100⥊7↑1 %% 100‿2⥊ (1e9×¬2|↕200) ⌈ 2/0=7|↕100
%USE eqvar ⋄  ≍˘⟜  1 _eqvar 100⥊7↑1 %% 100‿2⥊ (     2|↕200) ⌈ 2/0=7|↕100
%USE eqvar ⋄  ≍˘⟜1e9 _eqvar 100⥊7↑1 %% 100‿2⥊ (1e9× 2|↕200) ⌈ 2/0=7|↕100
%USE eqvar ⋄  ≍˘⟜'!' _eqvar 100⥊7↑1 %% ∾⟜'!'○•internal.Keep˘ 0=7|↕100
%USE eqvar ⋄ ≍˘_eqvar˜ 3‿3⥊↕9 %% 3‿2‿3⥊0‿1‿2‿0‿1‿2‿3‿4‿5‿3‿4‿5‿6‿7‿8‿6‿7‿8
%USE eqvar ⋄ (2‿3‿4‿5‿1⥊↕11) ≍⎉2 _eqvar 2‿3‿4‿5‿1⥊↕7 %% (2‿3‿4‿5‿1⥊↕11) ≍○•internal.PureKeep⎉2 2‿3‿4‿5‿1⥊↕7
!"𝕨˘𝕩: Argument frames don't agree (3‿4 ≡ ≢𝕨, 5‿4 ≡ ≢𝕩, common frame of 1 axes)" % (3‿4⥊2) ≍˘ 5‿4⥊2
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (⟨4⟩ ≡ ≢𝕨, ⟨5⟩ ≡ ≢𝕩)" % (3‿4⥊2) ≍˘ 3‿5⥊2
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (2‿2‿2 ≡ ≢𝕨, 2‿3‿2 ≡ ≢𝕩)" % (3‿2‿2‿2⥊2) ≍˘ 3‿2‿3‿2⥊2
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (4‿1 ≡ ≢𝕨, ⟨4⟩ ≡ ≢𝕩)" % (3‿4‿1⥊0) ≍˘ 3‿4⥊0
(<"ab") ≍˘  2⥊"cd" %% 2‿2⥊⟨"ab", 'c', "ab", 'd'⟩
(<"ab") ≍˘˜ 2⥊"cd" %% 2‿2⥊⟨'c', "ab", 'd', "ab"⟩
"ab" ≍⎉1 4‿2⥊"cd" %% 4‿2‿2⥊"abcdabcdabcdabcd"
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (⟨⟩ ≡ ≢𝕨, ⟨2⟩ ≡ ≢𝕩)" % ≍⟜"ab"˘ "cd"
!"𝕨≍𝕩: 𝕨 and 𝕩 must have equal shapes (⟨2⟩ ≡ ≢𝕨, ⟨⟩ ≡ ≢𝕩)" % "ab"⊸≍˘ "cd"

(
  %USE IS_HEAPVERIFY
  # big ˝˘ & `˘ tester
  _basicArgs ← { Test _𝕣 ranks:
    {𝕊f: {{f Test 0‿1⥊˜ 𝕩⊏0‿2‿4‿8‿32}¨ ↕𝕩⥊3 ⋄ 1}¨ ranks}¨ +‿∧‿∨‿=‿≠‿⊣‿⊢
  }
  
  # w F _thing x tests F _thing⎉w x
  _testFoldCells ← {∨´𝕗=⊢‿⊣? 0=×´(-𝕨)↑≢𝕩? 1; heapverify? 0=≠⥊𝕩? 1 ⊣ 𝔽˝⎉𝕨 𝕩; ! (𝔽˝⎉𝕨  ≡ 𝔽˝○•internal.PureKeep⎉𝕨) 𝕩}
  _testScanCells ← {                         heapverify? 0=≠⥊𝕩? 1 ⊣ 𝔽`⎉𝕨 𝕩; ! (𝔽`⎉𝕨  ≡ 𝔽`○•internal.PureKeep⎉𝕨) 𝕩}
  
  {1 𝕨 _testFoldCells 𝕩} _basicArgs 2‿3‿4
  {1 𝕨 _testScanCells 𝕩} _basicArgs 2‿3‿4
  {2 𝕨 _testScanCells 𝕩} _basicArgs 3‿4
  {2 𝕨 _testScanCells 𝕩} _basicArgs 3‿4
  
  ⟨0, 0‿1, 1‿0, 2‿2, 1, 10, 10‿1, 1‿10, 30⟩ {
    𝕨‿𝕩 ⥊¨↩
    sh ← 𝕨∾𝕩
    cr ← ≠𝕩
    +‿∧‿∨‿=‿≠‿⊣‿⊢ {
      cr 𝕎 _testFoldCells 𝕩
      cr 𝕎 _testScanCells 𝕩
    }⌜ {0=×´sh? 𝕩; ∾⟨𝕩, ¬⌾⊑¨ 𝕩, ¬⌾(¯1⊑⥊)¨ 𝕩⟩} sh⊸⥊¨ 0‿1
  }⌜ ⟨0, 1, 2, 8, 32, 8‿1, 4‿8, 4‿2, 59, 60, 63, 80, 81, 200, 640, 641⟩
)
