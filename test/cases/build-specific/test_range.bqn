# needs: -DTEST_RANGE
"basic test doesn't work; are you on a -DTEST_RANGE build?" ! 1‿9‿1 ≡ •internal.Temp 3‿1‿4‿1‿5‿9

%DEF invalid Invalid ← {·‿·‿0: 1; s‿e‿1: (s<-2⋆52) ∨ e>2⋆52}∘•internal.Temp

≢(⟨⟨0‿9‿1,↕10⟩ ⋄ ⟨¯5‿¯3‿1 ⋄ ¯5‿¯3‿¯4‿¯4‿¯4‿¯4‿¯4⟩⟩∾{⟨⟨¯2,𝕩-3,1⟩,¯2+↕𝕩⟩}¨1+↕100) {exp‿a𝕊𝕩: exp (⋈!≡) •internal.Temp 𝕩•internal.Variation a}⌜ "Ai8"‿"Ai16"‿"Ai32"‿"Af64"
T←⋈ ! ⊣ ≡ ·•internal.Temp "Ab"•internal.Variation⊢ ⋄ ≠{𝕊n: 1‿1‿1 T 𝕩⥊1 ⋄ 0‿0‿1 T 𝕩⥊0 ⋄ 0‿1 {0‿1‿1 T (¬𝕨)⌾(𝕩⊸⊑) n⥊𝕨}¨⍟(n>1) 2•rand.Range n}¨1+↕500
%USE invalid ⋄ Invalid¨ ⟨↕4, -⊸∾ 2⋆↕50, π×↕4, 10⥊2⋆60⟩ %% 0‿0‿1‿1
%USE invalid ⋄ ⟨2⋆63, 1.5, 0÷0⟩ {𝕨!Invalid 𝕨⌾(𝕩⊸⊑) 20⥊0}⌜ ↕20
%USE invalid ⋄ p←⟨1+2⋆-52, 1-2⋆-53⟩ ⋄ {𝕩!Invalid 𝕩⌾(10⊸⊑) 20⥊0}¨ ⟨∞, ¯∞, 0.1, ¯0.1⟩ ∾ ((1∾p) ×⌜ -⊸∾ 2⋆54+↕12) ∾○⥊ p ×⌜ 2⋆↕70
≠{! 0‿0‿1 ≡ •internal.Temp 𝕩↑(𝕩⥊0)∾10⥊0÷0}¨ 1+↕10
{𝕩!0= 2⊑•internal.Temp (0÷0)¨⌾((⍷𝕩)⊸⊏) 10⥊0}¨ ↕10‿10‿10
