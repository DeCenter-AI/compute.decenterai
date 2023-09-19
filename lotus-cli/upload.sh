#! /bin/sh

# lotus wallet new bls
# code ~/.lotus/config.toml

# https://lotus.filecoin.io/lotus/configure/defaults/

# 1. Prepare your data. For example, you can create a dummy file with random data.
dd if=/dev/urandom of=5gb-filecoin-payload.bin bs=1M count=52
# dd if=/dev/urandom of=5gb-filecoin-payload.bin bs=1M count=5200

# 2. Import the payload into the Lotus daemon.
lotus client import 5gb-filecoin-payload.bin

# 3. Create a storage deal with a Filecoin storage provider. You can find suitable providers using the Filecoin Plus Registry.
lotus client deal
