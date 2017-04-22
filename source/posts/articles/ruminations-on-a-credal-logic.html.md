---
:title: Ruminations on a Credal Logic
:tags: faith, logic, epistemology
:date: 2016-09-20
image: images/credal_logic.png
---
How do we understand our faith? More precisely, how do we reason deeply and precisely as faith-adherents? Or, perhaps most precisely, how might our faith shape our reason? Do we have a faith seeking the light of understanding, or a faith seeking out understanding with its light?

## 0: A Logical Primer

### 0.1: On the Law of Non-Contradiction

>The most certain of all basic principles is that contradictory propositions are not true simultaneously. (Aristotle, _Metaphysics_ 1011b13-14)

One of the bedrocks of modern rationality, of contemporary logic, is the so-called [Law of Non-Contradiction][2485-0001] (LNC), quoted above. A contradiction, expressed symbolically, is simply `P & ~P`; or, expressed logically, "the proposition `P` and its contradiction `not-P`". This law of rationality states that no such contradictions can or do exist; that is, symbolically, `~(P & ~P)`, or logically, "it is not the case that both the proposition `P` and its contradiction `not-P` are both true (at the same time in the same way)". The reason that this proposition _must be_ true, for the system of logic, is that _any_ contradiction allows for _any_ proposition to be logically deduced. Let's quickly run through a logical argument that begins from a contradiction:

~~~
1. All X is Y and not all X is Y            (P & ~P)
2. All X is Y                               (P)
    [by Conjunctive Elimination]
3. Not all X is Y                           (~P)
    [by Conjunctive Elimination]
4. All X is Y or {something impossible}     (P v Q)
    [by Disjunctive Introduction]
5. {something impossible}                   (Q)
    [by Disjunctive Syllogism]
~~~

Given the logical rules for conjunctions ("and"/`&`) and disjunctions ("or"/`v`), any proposition (`Q`) can be logically deduced from a contradiction (`P & ~P`). This is the so-called "[Principle of Explosion][2485-0002]" (or "ECQ", from its early Latin form _ex contradictione (sequitur) quodlibet_).

### 0.2: On the Law of the Excluded Middle

>It is necessary for the affirmation or the negation to be true or false. (Aristotle, _On Interpretation_, 9.18a28-29)

A corollary to the Law of Non-Contradiction is the so-called [Law of the Excluded Middle][2485-0003] (LEM). Symbolically, it is represented as the disjunction `P v ~P`, logically, we could express it as "it is the case that either the proposition `P` is true or `not-P` is true". I call it a corollary of the LNC because we can actually deduce its truth from the LNC. Consider: if it is true that `P` and `not-P` cannot both be true, then it is false that both `P` and `not-P` are both true. In order for a conjunction to be false, one of its conjucts must be false. Thus, either `P` or `not-P` must be false. Moreover, if `P` is false, then `not-P` is true; and, if `not-P` is false, then `P` is true. Thus, either `P` or `not-P` must be true. Symbolically, we might express that deduction as:

~~~
1. ~(P & ~P) => true
2. P & ~P => false
3. (P => false) v (~P => false)
4. (~P => true) v (P => true)
5. P v ~P
~~~

This principle of rational thought is called the "excluded middle" because it means that there is no middle ground between truth and falsity.

### 0.3: On Definite Descriptions

>Denoting phrases never have any meaning in themselves, but every proposition in whose verbal expression they occur has a meaning. (Russell, "On Denoting")

The LNC and the LEM are two of the three so-called "[Laws of Thought][2485-0004]" (the third (first really) is the [Law of Identity][2485-0005] (`A = A`)). Whether we know it or not, whether we think about it or not, these principles undergird all of our thought. Yet even these foundational principles of rational thought are not without complications. The LEM, for example, was often criticized for failing to properly or fully handle propositions about non-existent subjects. Consider the proposition "All unicorns have horns". The LEM compels us to state that either "All unicorns have horns" is true _or_ "All unicorns do not have horns" is true; yet, to state that either of these propositions is true would seem to imply that "unicorns" exist. One of the most famous and influential solutions to this problem is Bertrand Russell's theory of [Definite Descriptions][2485-0006] ("On Denoting", 1905). In simplified form, Russell suggests that propositions of this sort (e.g. denoting propositions) should be considered logically as containing an implicit existential proposition. We might restate our proposition as "There exists at least one thing such that it is called 'unicorn' and it has a horn". This is what we are really logically implying, in Russell's view, when we assert that "All unicorns have horns"; that is, we assume the existence of our subject and then define it by describing it.

## 1: Credal Propositions

### 1.1: Faith, Reason, and Truth Defined

>What does Jerusalem have to do with Athens, the Church with the Academy, the Christian with the heretic? Our principles come from the Porch of Solomon. (Tertullian, _Prescriptions against Heretics_ 7)

The question "What does Jerusalem have to do with Athens" is often abstracted to the form "What does _faith_ have to do with _reason_"? But what do we mean by these terms? I believe that for many reason concerns itself with the realm of justified (or justifiable) belief and faith that of non-justified (or non-justifiable) belief. Both are, however, concerned primarily with _belief_, and thus with propositions. Moreover, for many, truth equates to [justified true belief][2485-0007]. However, insofar as truth is defined as justified true belief, faith is excluded from truth. And yet it is a foundational proposition of our faith that God is the source of all truth, is Truth itself. This is the first gap between a common understanding of faith, reason, and truth.

### 1.2: On Paradoxical Propositions of our Faith

>No sooner do I conceive of the One than I am illumined by the splendour of the Three; no sooner do I distinguish Three than I am carried back into the One. When I think of any of the Three, I think of Him as the Whole, and my eyes are filled, and the greater part of what I am thinking escapes me. I cannot grasp the greatness of that One so as to attribute a greater greatness to the rest. When I contemplate the Three together, I see but one torch, and cannot divide or measure out the undivided light (Gregory of Nazianzus, _Orations_ 40.41)

One of the central propositions of our Christian faith is the Trinity; God is three and God is one. A central proposition concerning the nature of Jesus Christ is the Incarnation; Jesus is God and Jesus is man. These two foundations of the Christian faith are, in simplest form, paradoxes. Note, I call them "paradoxes" and not "contradictions", for, where they "contradictions", they would conflict with the LNC and stand in opposition to the foundations of human rationality. Indeed, there has been much effort of the thousands of years of Christian thought to show with clarity and adroitness that these and all articles of Christian faith are indeed rational. We need look no further than the work of the [Cappadocian Fathers][2485-0008] in articulating the Trinity with respect to "substance" (_ousia_) and "persons" (_hypostaseis_). Propositions of the Christian faith of this sort may _appear_ to be contradictions, but they are not; they are merely paradoxes, mysteries of the faith (_mysteria fidei_).

### 1.3: A Cartesian Re-Assessment

>Faith seeking understanding (St. Anselm)

In René Descartes' _Meditations on First Philosophy_, the philosopher begins by discarding all beliefs, all propositions, that he does not know for certain, and then attempts to build back up a system of beliefs by working systematically from what he can know for certain (_cogito ergo sum_). One consequence of this methodical skepticism is that it immediately highlights the hierarchy of our beliefs. It separates the axioms from the theorems.

It seems to me that with respect to articles of the Christian faith, the principles of reason are treated as axiomatic. We take pains to demonstrate how the mysteries of our faith adhere to the LNC, we struggle to articulate our terms and clarify our meaning, we shine the light of logic on these dark mysteries. And indeed, why should we not? The system of logic reflects the ordered, rational nature of God, does it not? Our minds are made in the image of God, are they not? Our faith should seek understanding in the light of logic, should it not?

## 2: A Christian Aetiology of Epistemology

### 2.1: On the Tree of the Knowledge of Good and Evil

>Behold, the man has become like one of us in knowing good and evil. Now, lest he reach out his hand and take also of the tree of life and eat, and live forever. (_Genesis_ 3:22)

Epistemology is at the center of the biblical narrative of the Fall. At the heart of Eden lie two trees: the Tree of Life and the Tree of the Knowledge of Good and Evil (Gen. 2:9). The first command God gives his human creation is “You may surely eat of every tree of the garden, but of the tree of the knowledge of good and evil you shall not eat, for in the day that you eat of it you shall surely die” (Gen. 2:16b-17). And it is, of course, this Tree of the Knowledge of Good and Evil that Eve and Adam eat from, and "[their] eyes were both opened" (Gen. 3:7a).

Now, the story of the Fall is rich with meaning, and there is much to be said and learned from it; however, I fear that the epistemic implications of this narrative are too often underconsidered. Whatever "knowledge of good and evil" might mean--experiential knowledge, a merism for knowledge generically, moral knowledge, etc--it is epistemic definitionally. Before the Fall the nature of knowledge, of reason, was in one state; and, after the Fall, it was in another. I believe this simply must be true, even if the delta is as simple as pre-Fall humanity did not have propositional knowledge of the concepts "good" and "evil", and post-Fall they did. The Fall, among its many consequences, represents a state change in human knowing.

Though we cannot know with any confidence what the epistemic state change was, I offer the following as my interpretation.

### 2.2: On Binary Thinking

I have always been fascinated by the fact that two of the most foundational axioms of logic concern contradictions. While the LNC and the LEM certainly strike the mind as intuitive, it is difficult to articulate a reason why these two propositions _must be_ foundational for thought. What is it about contradictions that proves so intuitively foundational to us? Well, for one, contradictions are logically-exhaustive binaries. If we think in terms of sets, `S` and `not-S`, regardless of the definition of `S`, would account for any and all `x`. Building a logical system atop logically-exhaustive entities must be more effective and efficient than the alternative (behold! another logically-exhaustive binary). In addition, contradictions make use of nothing but negation, a primitive logical operator in basically all propositional logical systems. Few movements of the mind would appear to come as naturally to the human person as negation. Yet again, however, we might ask, why? Why is negation a movement of the mind at all? Why is it so basic? Why are we seemingly drawn to the contradictions negation so easily creates?

Well, I'm inclined to think that some part of the answer lies in the Genesis account of the Fall. To have eaten of the Tree of the Knowledge of Good and Evil was to ground "knowledge" upon binaries, of the sort "good and evil". To have eaten of the Tree of the Knowledge of Good and Evil was to have introduced analytical thinking (in the etymological sense, "thinking that separates"). To have eaten of the Tree of the Knowledge of Good and Evil was to have made negation a primitive logical operation ("good and evil" logically equaling "good and not-good").

## 3: A Credal Logic

Now, none of this is to suggest that analytical thinking, negation, or binaries are "bad" or "wrong" or even "inferior" to anything. They are a necessary aspect of epistemology, of logic. However, this particular aetiology of epistemology, for me at least, opens up another gap between faith and reason. Faith is built on top of propositions of the (simplified) sort: `3 = 1` or `100 + 100 = 100`; reason is built on top of propositions of the sort: `(3 = 3)`, and `(1 = 1)`, and `(3 ~= 1)`. No matter what we do, there will always between tension between faith and reason; certain credal propositions of faith will always _at best_ be paradoxes in the light of reason. The question, to my mind, then becomes: in which direction is that tension resolved? Put another way, what does it mean for faith to seek understanding? Do we seek to understand our faith in the light of logical reason, or do we seek to understand our logical reason in light of our faith? I believe there is great value to be found in the latter, but what does that even look like?

First, let our credal logic begin from paradox and end in paradox. Instead of looking to resolve the paradoxes in the mysteries of our faith, to find refuge by demonstrating the ways, means, and degrees to which they are not contradictions, let us instead look to explore the paradoxes, their shape, nature, and edges.

### 3.1: 1 = 0.9999... and the Trinity

In an overly-simplified mathematical form, we might represent the propositional content of the Trinity as the paradoxical `3 = 1`. This is a paradox of identity. In looking to explore this paradox, we might turn to a particular mathematical paradox of identity: `1 = 0.9999...`.

#### 3.1.1: 1 = 0.9999...

To begin, let me prove this identity statement:

~~~shell
# Define the infinitely-repeating decimal as a variable
k = 0.9999...
# Multiply both sides of the equation by 10
10k = 9.9999...
# Subtract the larger portions by the smaller portions
(10k - k) = (9.9999... - 0.9999...)
# Since the infinitely-repeating decimals are both infinitely long,
# subtraction cancels them out
9k = 9
# Divide both sides of the equation by 9
k = 1
# Replace k with our original identity
1 = 0.9999...
~~~

Now, this proof may perhaps feel a bit fishy to you; you may think that we are mathematically cheating somewhere, but I can promise you that every single step is totally valid. And if every step is totally valid, then the conclusion is valid. But how can this be and what does this mean?

This "problem", this seeming incongruity, arises because we have a hard time grappling with infinity. To put it another way, we underestimate the weight of that ellipsis. So let's dig into that ellipsis a bit. What does `0.9999...` really mean, really represent? Well, we all remember from elementary school that decimals can also be represented by fractions, so let's try to represent this decimal by a fraction. Unfortunately, there is no simple fraction to represent this number (like `0.3333...` being representable by \\(\frac{1}{3}\\)). However, we can break this decimal down. We know that `0.9` is simply \\(\frac{9}{10}\\), and `0.09` is \\(\frac{9}{100}\\), and `0.009` is \\(\frac{9}{1000}\\) and so on. We also know that `0.9 + 0.09 + 0.009 = 0.999`. So, we could represent `0.9999...` fractionally as:

$$\frac{9}{10} + \frac{9}{100} + \frac{9}{1000} + \frac{9}{10000} + \ldots$$

In mathematics, this is called an [_infinite sum_][2485-0009] or an _infinite series_; we are adding terms together to infinity. If you recall from your high school math class, you can represent an infinite sum with what is called **[sigma notation](https://en.wikipedia.org/wiki/Summation#Capital-sigma_notation)**, and our infinite sum above can be represented as:

$$\sum_{n=1}^{\infty} \frac{9}{10^n}$$

This is simply a more concise way of writing the larger sum of the fractions above.

Infinite sums are truly fascinating, and I hope to write more about them in the future, but for now I want to focus on one characteristic in particular. All infinite sums fit into one of two categories: _convergent_ or _divergent_. Now, these are math-jargon terms that mean relatively simple things. An infinite sum is _convergent_ if it converges on a finite number. The language you might remember from your calculus class is that the _limit_ of the infinite sum _approaches_ a finite number. So, a _convergent infinite sum_ is an infinity that touches the finite. In contrast, a _divergent infinite sum_ is one that has no limit, one that grows to infinity. A stock example is

$$\sum_{n=1}^{\infty} \frac{1}{n}$$

or

$$1 + \frac{1}{2} + \frac{1}{3} + \frac{1}{4} + \ldots$$

This is an infinite sum that approaches infinity, that is, it _diverges_, it does not have a finite limit, it is unbounded.

Returning to our infinite sum, we have enough context now to see that saying `1 = 0.9999...` is really just one way of saying that the summation of \\(\frac{9}{10^n}\\) as `n` goes from 1 to infinity is a convergent infinite sum that converges on 1.

#### 3.1.2: On Infinity touching the Finite

Paradoxes abound when the infinite collides with the finite. On the one hand, it is quite clear that `1` _does not equal_ `0.9999...` for the simple reason that `1` is a finite integer and `0.9999...` is an infinite series. If _equality_ is _categorical identity_, then `1` and `0.9999...` are not equal. On the other hand, this whole post has shown that `1` _does equal_ `0.9999...`. If _equality_ is _referrential identity_, then `1` and `0.9999...` are equal. Now, note that I call this a paradox and not an antinomy. I want to define these two terms clearly and distinguish them.

In my parlance, a **paradox** is a _seeming_ contradiction, while an **antinomy** is an _actual_ contradiction; that is, a paradox is resolvable and an antinomy is not. It is important, however, to note that resolving a paradox _does not_ mean that one side "wins" and the other "loses", that one proposition is "right" and the other is "wrong"; instead, it means that we can rationally make sense of the difference between the two propositions. This is why I used the if-then statements above. It is not that one of the propositions is "right" or "wrong", it is that we can enumerate the conditions under which each one would be "right" and the other "wrong". An antinomy does not submit itself to such enumeration; we cannot articulate the conditions under which one side is "right" and the other is "wrong". So, if I were to abstract out my definitions of _paradoxes_ and _antinomies_, I would describe them thusly:

> A paradox is composed of a proposition (`P`) and its negation (`not-P`) such that the conditionals "if `conditions for P`, then `P`" and "if `conditions for not-P`, then `not-P`" are both true, and thus the conjunction "if `conditions for P`, then `P` and if `conditions for not-P`, then `not-P`" is also true.

> An antinomy is composed of a proposition (`P`) and its negation (`not-P`) such that there are no conditions for `P` or `not-P` and the conjunction "`P` and `not-P`" is true.

After exploring a convergent infinite sums, we have a clearer understanding of identity paradoxes like `1 = 0.9999... and 1 != 0.9999...`. If we express that proposition in the form of the paradox explained above, we would express that proposition as "if equality means referential indentiy, then 1 = 0.9999... and if equality means categorical identity, then 1 != 0.9999...".

#### 3.1.3: 3 = 1

We could now return to the Trinity and see that the orthodox articulation of this article of faith maps well onto this understanding of the shape of an identity paradox. We might recast the Cappadocian Fathers' articulation of the Trinity as a proposition in the form: "if identity is defined by essence, then God is one and if identity is defined by person, then God is three".

#### 3.1.4: On Denotation

One consequence of this approach to paradoxical identity statements is an analytical approach similar to Russell's definite descriptions. Where definite descriptions analyze the subject of a proposition into an existential proposition, this method analyzes the verb of a proposition into a meaning-centric conditional.

### 3.2: Wave-Particle Duality and the Incarnation

For now, how about we leave this as an exercise for the reader? ;)

## 4: Ruminating

I cannot help but to feel that there is a value in pursuing a "credal logic", in exploring the myriad ways that the propositions undergirding our faith illuminate ways of thinking that deepen "standard logic". Moreover, it seems to me to be the case that these ways of thinking found in and through credal propositions align profoundly with various "secular" rationalities. All truth is indeed God's truth. Finally, I am convinced that pushing against the boundaries of binary thinking is healthy, not only for the Christian, but for the human.

However, I believe that in one respect the Christian has an opportunity the non-Christian does not. The non-Christian, it seems to me, can never move beyond the boundaries of binary thinking and retain "rational" thinking; they can push but never break. The Christian, however, may very well be able to be "rational" without binary thinking. Or, to put it more concretely, it might simply be the case that God is three and one, that God is a contradiction, that Christ is a contradiction. It might be the case that when the infinity that is the divine intersects the finite that is this reality, contradictions arise (and not mere paradoxes). And, it might be the case that through faith, through revelation, we have the ability to think "rationally" with a credal logic grounded on contradictions. It might be the case...

[2485-0001]: https://en.wikipedia.org/wiki/Law_of_noncontradiction
[2485-0002]: https://en.wikipedia.org/wiki/Principle_of_explosion
[2485-0003]: https://en.wikipedia.org/wiki/Law_of_excluded_middle
[2485-0004]: https://en.wikipedia.org/wiki/Law_of_thought
[2485-0005]: https://en.wikipedia.org/wiki/Law_of_identity
[2485-0006]: https://en.wikipedia.org/wiki/Definite_description
[2485-0007]: https://en.wikipedia.org/wiki/Justified_true_belief
[2485-0008]: https://en.wikipedia.org/wiki/Cappadocian_Fathers
[2485-0009]: http://www.waldron-math.com/BCCalculus/ClassNotes/Ch9/9.1_Infinite%20Series.pdf
