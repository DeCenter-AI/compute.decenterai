from multibase import is_valid_multibase


def is_cid(cid: str):
    return is_valid_multibase(cid)


