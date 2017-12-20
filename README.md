
### About

Geth-based private / local blockchain for **testing** purposes.

### Usage

#### 1. Start

```bash
$ docker-compose rm -f && docker-compose up --build --scale bootnode=2 --scale geth=3
```

#### 2. Attach

```bash
$ docker-compose exec --index=1 geth geth attach
```

[//]: # ( vim:set ts=2 sw=2 et syn=markdown: )
