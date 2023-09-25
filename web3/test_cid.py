from web3.cid import is_cid


def test_is_cid():
    valid_cid = "QmX7n8dK3y5a3k4"
    assert is_cid(valid_cid) is True

    invalid_cid = "invalid_cid"
    assert is_cid(invalid_cid) is False
