#----------------------------------------------------
#
# Resiliency map overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-resiliency-map

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[resiliency_overlay]
name: ResiliencyOverlay
group: Emergency
description: Resiliency Overlay
path: /home/maposmatic/styles/Mapnik-resiliency-map/resiliency.xml

EOF

echo "  resiliency_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays

