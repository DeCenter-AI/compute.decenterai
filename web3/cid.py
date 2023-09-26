from cid import is_cid as is_ipfs_cid


def is_cid(cid: str):
    return is_ipfs_cid(cid)
