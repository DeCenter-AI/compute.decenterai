from web3.cid import is_cid


def test_is_cid():
    valid_cid = "QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x"
    assert is_cid(valid_cid) is True

    invalid_cid = "invalid_cid"
    assert is_cid(invalid_cid) is False
