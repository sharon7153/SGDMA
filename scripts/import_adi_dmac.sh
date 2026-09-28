#!/bin/bash
set -e
ADI=~/Workspace/adi_hdl
PRJ=~/Workspace/SGDMA
DST=$PRJ/rtl/third_party/adi_hdl/library
mkdir -p $DST/{axi_dmac,common,util_cdc,util_axis_fifo}

# 1) Copy pristine upstream RTL
cp $ADI/library/axi_dmac/*.v $ADI/library/axi_dmac/*.vh $DST/axi_dmac/
cp $ADI/library/common/{ad_mem_asym.v,ad_mem.v,up_axi.v} $DST/common/
cp $ADI/library/util_cdc/*.v $DST/util_cdc/
cp $ADI/library/util_axis_fifo/{util_axis_fifo.v,util_axis_fifo_address_generator.v} $DST/util_axis_fifo/
cp $ADI/LICENSE* $PRJ/rtl/third_party/adi_hdl/ 2>/dev/null || true

# 2) Apply local patches
for p in $PRJ/patches/*.patch; do
  [ -e "$p" ] || continue
  echo "Applying $(basename $p)"
  git -C $PRJ apply "$p"
done

# 3) Record provenance
cat > $PRJ/rtl/third_party/adi_hdl/README.md << EOF
Upstream : https://github.com/analogdevicesinc/hdl
Branch   : $(git -C $ADI rev-parse --abbrev-ref HEAD)
Commit   : $(git -C $ADI rev-parse HEAD)
Note     : RTL only (vendor packaging files excluded).
           Do not edit files here directly. Add changes as patches/*.patch.

Local patches:
$(ls $PRJ/patches/*.patch 2>/dev/null | xargs -n1 basename | sed 's/^/  - /')
EOF

echo "Import done."
