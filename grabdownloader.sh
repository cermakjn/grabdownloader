#! /bin/bash
echo "Program is running"
echo `date`

#set variables
folder="/mnt/data/honza/.maildir/INBOX/new"
storage="/mnt/data/honza/grab"

#spustim synchronizaci mailu
offlineimap > /dev/null
echo "Fetching mail complete"

slozka=$folder
uloziste=$storage

#načte počet souborů v new +1
radky=`ls -l $slozka | wc -l`

#zkontroluju jesti je nějaký nový mail
if [ "$radky" -gt "1" ]; then

#nový email je, určím jejich počet, který je proměná řádky -1
pocet_mailu=`expr $radky - 1`

#projedu všechny maily
for (( i=1; i<=$pocet_mailu; i++ ))
do
#chci pracovat se souborem, tak si najdu jeho nazev
nazev=`ls -l $slozka | awk '{print $9}' | tail -$i | head -1`

#ted soubor otevřu a vyberu z něj adresu pro stažení grabu
adresa=`cat $slozka/$nazev | grep  dvbstorage.siliconhill.cz | head -1`

#název souboru
soubor=`echo $adresa | awk -F/ '{print $5}'`

#staženo bude do úložiště pod názvem
wget -o /dev/null -O $uloziste/$soubor $adresa
echo File $soubor downloader at `date`.

done

#a promažu maily
mv $slozka/* /mnt/data/honza/.maildir/INBOX/hotovo/.

else

echo Is not new grab for download.

fi
