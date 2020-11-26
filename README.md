Firebase RDB emulator running in Docker
---------

This repository contains a simplistic example of a web app that allows reproducing an issue while running the 
Firebase RDB emulator (just emulator later on) in a Docker container.

# Prerequisites

1. Docker 19.03.
2. NodeJS 12+.

# Running without Docker

First let's make sure the example works fine when the emulator is started locally.

In order to start the emulator locally, go over the following steps:

1. Run `npm i` to install the emulator.
2. Run `npm run start` to start the emulator.

Now, open `index.html`. You must be able to click on the `Write to RDB` button an upon clicking see entries stored
in the emulator.

# Running with Docker

First, let's build the emulator image. Execute the following command to build the image:

```bash
docker build -t firebase-emulator .
```

The image uses `firebase-docker.json` and copies it into the container as `firebase.json`. The `host` is set to 
`0.0.0.0` in order to be able to access the started emulator from the host OS.

Start the emulator with ports forwarding using the following command:

```bash
docker run --rm -p=54897:54897 firebase-emulator
```

Now, open `index.html`. Open Chrome dev tools and click on the `Write to RDB` button. 

You must be able to trace the first connection request sent to the emulator `localhost:54897`, but the others 
(redirected by the emulator) now ask the client to connect to `0.0.0.0` instead. 
And the `0.0.0.0` is not reachable on any OS.

Here is a dump of requests being sent in chronological order:

```
---
http://localhost:54897/.lp?start=t&ser=75118654&cb=1&v=5&ns=fake-server

response: 

function pLPCommand(c, a1, a2, a3, a4) {
parent.window["pLPCommand1"] && parent.window["pLPCommand1"](c, a1, a2, a3, a4);
}
function pRTLPCB(pN, data) {
parent.window["pRTLPCB1"] && parent.window["pRTLPCB1"](pN, data);
}
         pLPCommand('start','1','nxExCrtfPv');
pRTLPCB(0,[{"t":"c","d":{"t":"h","d":{"ts":1606404821657,"v":"5","h":"0.0.0.0:54897","s":"kIsNLt22OP58UjyvSTXykWsJGyxPfWEA"}}}]);

---
http://0.0.0.0:54897/.lp?id=1&pw=nxExCrtfPv&ser=42313306&ns=fake-server
---
http://0.0.0.0:54897/.lp?dframe=t&id=1&pw=nxExCrtfPv&ns=fake-server
---
http://0.0.0.0:54897/.lp?id=1&pw=nxExCrtfPv&ser=42313307&ns=fake-server&seg0=0&ts0=1&d0=eyJ0IjoiZCIsImQiOnsiciI6MSwiYSI6InMiLCJiIjp7ImMiOnsic2RrLmpzLjgtMS0xIjoxfX19fQ..
---
http://0.0.0.0:54897/.lp?start=t&ser=96003070&cb=2&v=5&ls=kIsNLt22OP58UjyvSTXykWsJGyxPfWEA&ns=fake-server
```
