import 'package:flutter/material.dart';

const String explanation =
    "I first envisioned this project thinking about Pokemon Go and reflecting on the question: What could I, as an individual, do right now to help make the world a better place? Well I would probably have to leave my house. It seemed like there could be an app for this sort of thing. As Pokemon Go plots \"gyms\" for \"trainers\" to meet, there could be a map with plots for ideas, groups, movements, etc.. something interesting enough to glance at, with the potential to inspire greater involvement.";

const List<String> infos = [
  explanation,
  "As I continued to play with this idea, I turned my attention to the elements that might be displayed. plotting a map is simple enough. But what would go on it?",
  "At the heart of things is information. doesn't it have to be? Along those lines I conceived of information interaction systems, visible from afar, with content sourced on location.",
  "I realized that the overall vision could be constructed in pieces. That's what this is, a piece. It does not have a clear association with any location; I'm focused on SE Michigan; the intention is to limit access to locals only. This can be achieved by only allowing initial access in person. I believe some community information processes could go a long way to combat misinformation we deal with in our online lives.",
  "the idea of a \"locals only\" forum could exist a number of ways. I've done my share of experimentation; I've arrived somewhere simple. There is no algorithm. Users vote on posts: popular posts stay at the top of the list, unpopular posts get deleted. The advantage of this is that underdiscussed issues can, hopefully, have more time in the light. The disadvantage is that there's no feed. The contents will likely be stagnant. The progression of conversation will depend on recurrent users adjusting their votes.",
  "Another consideration is the aspect of identity. How we engage with \"politics\" can affect how we think of ourselves. I believe this app separates ideas from self-image effectively by de-focusing on personal accounts and highlighting the ideas themselves.",
  "This is an app, but perhaps it's best considered as a process. There's something to be said for exploring solutions that engage us on the basic level, in the modern sense, as an app on our phone. Hopefully what I've built can be a useful resource that can develop meaningfully over time from a wide pool of ideas and interactions."
];

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(infos[page]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  page > 0
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              page--;
                            });
                          },
                          icon: const Icon(Icons.arrow_back))
                      : const SizedBox(
                          width: 10,
                        ),
                  page < infos.length - 1
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              page++;
                            });
                          },
                          icon: const Icon(Icons.arrow_forward))
                      : const SizedBox(
                          width: 10,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
