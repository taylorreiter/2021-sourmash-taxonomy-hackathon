[![Binder](https://binder.pangeo.io/badge_logo.svg)](https://binder.pangeo.io/v2/gh/bluegenes/2021-sourmash-taxonomy-hackathon/main)

# sourmash taxonomy visualization brainstorm

**Relevant Issues/PRs**:
+ https://github.com/dib-lab/sourmash/issues/1515 
+ https://github.com/dib-lab/sourmash/issues/969
+ https://github.com/dib-lab/sourmash/issues/1011#issuecomment-639537026
+ https://github.com/dib-lab/sourmash/issues/985#issuecomment-626215382
+ https://github.com/dib-lab/sourmash/pull/1543

**Relevant Repos**:
+ https://github.com/dib-lab/2018-ncbi-lineages
+ https://github.com/dib-lab/sourmash_databases
+ https://github.com/dib-lab/2019-12-12-sourmash_viz
+ https://github.com/luizirber/2020-cami
+ https://github.com/dib-lab/sourmash_databases/pull/11 <- build databases from assembly_stats.txt
    + `/home/irber/sourmash_databases/outputs/lca/lineages`

[toc]


template: 
+ publication:
+ language:
+ execution environment:
+ github:
+ required input:

## plots that should be acheivable from sourmash gather results 

### krona taxonomy plot

+ publication: https://link.springer.com/article/10.1186/1471-2105-12-385
+ language: javascript, perl
+ execution environment: bash
+ github: https://github.com/marbl/Krona
+ required input: text file

![](https://i.imgur.com/djjLoNg.png)

### BURRITO interactive plot


+ publication:
+ language:
+ execution environment:
+ github:
+ required input:


![](https://i.imgur.com/rv5TULh.jpg)

### BioSankey

+ publication: https://www.degruyter.com/document/doi/10.1515/jib-2017-0063/html
+ language:
+ execution environment:
+ github:
+ required input:

**Biosankey (left)**
![](https://i.imgur.com/HukxxSf.png)

**Biosankey for change over time**
![](https://i.imgur.com/A2OgDQM.jpg)

### MetaCoder

+ publication: https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005404
+ language: R
+ execution environment: R
+ github:
+ required input:

![](https://i.imgur.com/ZuiM9c9.jpg)

### Heatmap

+ summary:
+ publication: NA; this particular heatmap is from MetaPhiAn but we could make our own
+ language: python, R
+ execution environment: python, R
+ github: NA
+ required input:

![](https://i.imgur.com/K8rIGf8.png)

### KEANU

+ summary: acheives the same style as other graphics, but in pure python. Could be good inspiration for viz notebooks?
+ publication: https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-019-2629-4
+ language: python
+ execution environment: python
+ github: https://github.com/IGBB/keanu
+ required input:

![](https://i.imgur.com/8SOkqyt.png)

![](https://i.imgur.com/CD5cnWh.png)

## plots that require substantially more compute or metadata etc.

### co-occurence of species in a group of metagenomes

+ summary: co-occurence would need to be calculated from gather-species level summaries...probably.
+ publication:
+ language:
+ execution environment:
+ github:
+ required input:

 
![](https://i.imgur.com/wjR1f6H.png)

### Iroki

+ publication: https://www.iroki.net/wiki
+ language:
+ execution environment:
+ github:
+ required input:

![](https://i.imgur.com/Pac03wr.png)
![](https://i.imgur.com/yKxJI2c.jpg)

