- Do not add unnecessary try/except. If an error happens, it should propagate to the user to make debugging with pdb easier;
- If you create md files with feature plans/descriptions, put them in `mds/claude` folder (create it if needed) in whatever dir you're working in;

Remember the zen of python when writing code (and in general).

```
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

**In any text you write (be it messages or reports)**  
- Do not use terms not introduced in the conversation. Use the user's terms, don't invent names.  
- Avoid excessive parenthetical detail; avoid parentheses when possible.
- Use clear, connected sentences instead of truncated shorthand. "X is in Y", not "X: in Y".  
- Prefer tables when presenting many numbers.  
- Avoid sentences that start with a verb e.g. "Follows from v2 run."
- Avoid double SVO sentences, like "The experiment failed to show what we are looking for, and table 2 shows that exactly" <- Just break it down into two "The experiment failed to show what we are looking for. You can see that in table 2."
- Avoid twitter-attention-grab phrasing. Sound neutral, not condescending. The banned list (and anything akin to these):  
	• "It's not X. It's Y"  
	• "It's exactly the kind of thing that most ..."  
	• "X carries a lot of weight here"  
	• "X? Not X, it's Y"  
	• "But here's the catch"  
	• "X is the real differentiator here"  
	• "This isn't about X. It's about Y."  
	• "It's worth noting that...", "That said,...", "Here's the thing:", "To be clear,...", "The reality is more nuanced."  
	• "one thing is clear:"  
	• "But here's the deal"  
	• "Here's why it matters"
	- The most important thing is
	- Which is precisely what
	- X matters and Y shows why
	- "Let me verify/show/demonstrate instead of arguing abstractly"
	- starting sentences with rather than...
	- "the single most" phrase

###### Concrete examples
- **Bad**: But that's different from *random* in the RMU sense, and the difference is what the paper's ablation is about.  **Better:** Notably, the ablation results show that the method performs better then random when measuring RMU.
- **Bad** This asymmetry is, we think, the single most useful framing for the results, and the paper did not state it clearly. **Better** Although the paper did not emphasize it, this asymmetric setting is a very interesting experiment setup that revealed unexpected behaviors.
- **Bad** Caveats matter: these were unguardrailed research configurations, some tasks were misconfigured so no legitimate solution existed, and AISI says nothing was maliciously intended — the deception fell out of single-minded task pursuit, which is the alignment argument moving from theory to logs. **Better** It's important to note that the experiments were run without guardrails, and some of the tasks had no possible solutions due to misconfiguration. AISI says there was no malicious intent in the setup or the prompt, model deception occured spontaneously.
- **Bad** Thinking Machines answers the same question operationally in shipping Inkling and Inkling-Small: internal evals across CBRN/cyber plus a 17-language multimodal set, external red-teaming split across Scale AI, Handshake AI, FAR.AI, and Apollo Research, and an adversarial fine-tuning study on helpful-only variants — because refusal is treated as non-durable, "removable via a single direction in activation space." **Better** On a related note, Thinking Machines shipped Inkling and Inkling-Small models two weeks ago. Before release, they conducted thorough internal evaluations of model safety. They included tasks like CBRN and cyber attacks. Experiments also included 17-language multimodal benchmark testing models handling of unsafe requests involving images and videos, as well as external read-teaming benchmarks from Scale AI, Handshake AI, FAR.AI, and Apollo Research testing various methods of prompt injection. Further, they also conducted adversarial fine-tuning to stop the model from refusing, which is essential since the weights are released and unlearning refusal is fairly trivial.

