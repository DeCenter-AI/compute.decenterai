import os
from dataclasses import dataclass

from dotenv import load_dotenv
from icecream import ic
from lighthouseweb3 import Lighthouse

lh = Lighthouse(token="287cd8ac.6202ad1cca9c465a831c30b621ea09a8")


@dataclass
class LighthouseFile:
    name: str
    hash: str
    size: str

    @property
    def uploaded_url(self):
        return f"https://gateway.lighthouse.storage/ipfs/{self.hash}"


def upload(path: str) -> LighthouseFile:
    response = lh.upload(path)
    ic(response)

    data = response["data"]
    upFile = LighthouseFile(data["Name"], data["Hash"], data["Size"])

    return upFile


def download(cid: str, path_to_save: str) -> LighthouseFile:
    with open(path_to_save, "w") as f1:
        res = lh.downloadBlob(f1.buffer, cid)
        ic(f"ligthouse:downloaded {path_to_save}")
        data = response["data"]
        upF1 = LighthouseFile(cid, data["Hash"], data["Size"])
        ic(upF1)
        return upF1


if __name__ == "__main__":
    # TODO: get from environmetn variable
    lh = Lighthouse(token="287cd8ac.6202ad1cca9c465a831c30b621ea09a8")

    response = lh.upload(
        "/Users/hiro/Decenter/decenter.streamlit/compute.decenter-ai/samples/sample_v3/sample_v3.zip",
    )
    print(response)

    data = response["data"]

    upFile = LighthouseFile(data["Name"], data["Hash"], data["Size"])

    if not os.path.exists("data"):
        os.mkdir("data")

    sample_v3_cid = "QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1"
    sample_v3_cid = upFile.hash
    path_to_save = os.path.join("./data", f"{sample_v3_cid}.zip")

    with open(path_to_save, "w") as f1:
        res = lh.downloadBlob(f1.buffer, sample_v3_cid)
        print(res)

    # lh.download(sample_v3_cid) #TODO: just downloads in bytes

    load_dotenv()
