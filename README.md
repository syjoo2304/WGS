## **How to Use**

1. **Create Symlinks for BAM Files**:
   - Navigate to the `/BAM` directory:
     ```bash
     cd /WGS/BAM
     ```
   - Create symbolic links for the BAM files:
     ```bash
     ln -s /path/to/your/final_output.bam .
     ln -s /path/to/your/final_output.bai .
     ```

2. **Create Symlinks for VCF Files**:
   - Navigate to the `/VCF` directory:
     ```bash
     cd /WGS/VCF
     ```
   - Create symbolic links for the VCF files:
     ```bash
     ln -s /path/to/your/final_output.vcf .
     ln -s /path/to/your/final_output.vcf.gz .
     ```
