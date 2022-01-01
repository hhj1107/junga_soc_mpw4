sudo apt install -y tcsh csh tcl-dev tk-dev libcairo2-dev
sudo apt install -y gcc-riscv64-unknown-elf iverilog

git clone git://opencircuitdesign.com/magic
cd magic
git checkout $MAGIC_VERSION
./configure
make
sudo make install