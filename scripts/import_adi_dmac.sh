#!/bin/bash
set -e
ADI=~/Workspace/adi_hdl
PRJ=~/Workspace/SGDMA
DST=$PRJ/rtl/third_party/adi_hdl/library
mkdir -p $DST/{axi_dmac,common,util_cdc,util_axis_fifo}

cp $ADI/library/axi_dmac/*.v $ADI/library/axi_dmac/*.vh $DST/axi_dmac/
cp $ADI/library/common/{ad_mem_asym.v,ad_mem.v,up_axi.v} $DST/common/
cp $ADI/library/util_cdc/*.v $DST/util_cdc/
cp $ADI/library/util_axis_fifo/{util_axis_fifo.v,util_axis_fifo_address_generator.v} $DST/util_axis_fifo/
cp $ADI/LICENSE* $PRJ/rtl/third_party/adi_hdl/ 2>/dev/null || true

cat > $PRJ/rtl/third_party/adi_hdl/README.md << EOF
Upstream : https://github.com/analogdevicesinc/hdl
Branch   : $(git -C $ADI rev-parse --abbrev-ref HEAD)
Commit   : $(git -C $ADI rev-parse HEAD)
Note     : RTL only (vendor packaging files excluded). Do not modify files here.
EOF

echo "Import done."
