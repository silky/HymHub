# Copyright (c) 2015, Daniel S. Standage and CONTRIBUTORS
#
# HymHub is distributed under the CC BY 4.0 License. See the
# 'LICENSE' file in the HymHub code distribution or online at
# https://github.com/BrendelGroup/HymHub/blob/master/LICENSE.

# Fasta/GFF3 cleanup procedure for data sets obtained from NCBI.
ncbi_format()
{
  echo "[HymHub: $FULLSPEC] simplify genome Fasta deflines"
  gunzip -c $refrfasta \
      | perl -ne 's/gi\|\d+\|(ref|gb)\|([^\|]+)\S+/$2/; print' \
      > $fasta

  filtercmd=cat
  if [ -n "$1" ]; then
    filtercmd="grep -Ev $1"
  fi
  echo "[HymHub: $FULLSPEC] clean up annotation"
  gunzip -c $refrgff3 \
      | $filtercmd \
      | grep -v $'\tregion\t' \
      | grep -v $'\tmatch\t' \
      | grep -v $'\tcDNA_match\t' \
      | grep -v '###' \
      | grep -v '##species' \
      | tidygff3 2> ${gff3}.tidy.log \
      | gt gff3 -sort -tidy -o ${gff3} -force 2>&1 \
      | grep -v 'has not been previously introduced' \
      | grep -v 'does not begin with "##gff-version"' || true

  echo "[HymHub: $FULLSPEC] verify data files"
  shasum -c species/${SPEC}/checksums.sha
}
