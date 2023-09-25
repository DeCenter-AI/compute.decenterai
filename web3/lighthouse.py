from lighthouseweb3 import Lighthouse

from dotenv import load_dotenv
import os

from dataclasses import dataclass

import logging
from icecream import ic


@dataclass
class LighthouseFile:
    name: str
    hash: str
    size: str


def upload(path: str) -> LighthouseFile:
    response = lh.upload(path)
    ic(response)

    data = response['data']
    upFile = LighthouseFile(data['Name'], data['Hash'], data['Size'])

    return upFile


def download(cid: str, path_to_save: str) -> LighthouseFile:
    with open(path_to_save, 'w') as f1:
        res = lh.downloadBlob(f1.buffer, sample_v3_cid)
        ic(f"ligthouse:downloaded {path_to_save}")
        data = response['data']
        upF1 = LighthouseFile(cid, data['Hash'], data['Size'])
        ic(upF1)
        return upF1


if __name__ == "__main__":
    lh = Lighthouse(token='56c91764.0d69cc79074f460c86a9a6d0601a8f65')

    response = lh.upload("__init__.py")
    print(response)

    data = response['data']

    upFile = LighthouseFile(data['Name'], data['Hash'], data['Size'])

    if not os.path.exists('data'):
        os.mkdir('data')

    sample_v3_cid = "QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x"
    path_to_save = "./data/x.zip"

    with open(path_to_save, 'w') as f1:
        res = lh.downloadBlob(f1.buffer, sample_v3_cid)
        print(res)

    # lh.download(sample_v3_cid) #TODO: just downloads in bytes

    load_dotenv()
