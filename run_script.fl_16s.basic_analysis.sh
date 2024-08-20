# 2024.07.17 sindy@hunbiome.com

out_pth=${1} #/data/sindy/Research/Cosmax/24-03-25.Rice_extract.pacbio_10ea/
raw_pth=${out_pth}/rawdata
date=`date "+%Y-%m-%d"`
pb_out_pth=${out_pth}/${date}.analysis.pb_nb_16s

script_pth=/data/sindy/Source/metagenome_script/
F="AGRGTTYGATYMTGGCTCAG"
R="AAGTCGTAACAAGGTARCY"
rev_R="RGYTACCTTGTTACGACTT"

mkdir -p ${pb_out_pth}
#ln -sf ${pb_nb_16s_script}/main_absPth.nf ${pb_out_pth}/
#ln -sf ${pb_nb_16s_script}/databases/ ${pb_out_pth}/
#ln -sf ${pb_nb_16s_script}/env/ ${pb_out_pth}/
#ln -sf ${pb_nb_16s_script}/main.nf ${pb_out_pth}/
#ln -sf ${pb_nb_16s_script}/nextflow.config ${pb_out_pth}/
#ln -sf ${pb_nb_16s_script}/script ${pb_out_pth}/

${script_pth}/run_script.fl_16s.prepare_input.sh ${pb_out_pth} ${raw_pth} .fastq.gz 2
cut -f1 ${pb_out_pth}/manifest.txt  | awk -F"\t" '{if($1!="sample-id") print $1"\t"$1; else print $1"\tgroup"}' >  ${pb_out_pth}/metadata.txt
nextflow run ${script_pth}/HiFi-16S-workflow/main.nf --input ${pb_out_pth}/manifest.txt --metadata ${pb_out_pth}/metadata.txt -profile conda --outdir ${pb_out_pth}/results --run_picrust2 -resume

