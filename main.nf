#!/usb/bin/env nextflow
nextflow.enable.dsl=2

process foo {
    cpus 1
    memory 500.MB
    container "opensuse/leap:latest"
    input:
        path input_files
    output:
        path "files/*.txt", emit: files
    """
    mkdir files/
    cp ${input_files} files/
    """
}

process bar {
    cpus 1
    memory 500.MB
    container "opensuse/leap:latest"
    input:
        path collected_file
    output:
        path "${collected_file}.md5"
    """
    md5sum ${collected_file} > ${collected_file}.md5
    """
}

workflow {
    inputs = Channel.fromPath("${baseDir}/assets/input/*.txt")
    groups_of_names = inputs.collate(2)
    foo(groups_of_names)
    foo.out
        .collect()
        .flatten()
        .collectFile(name: 'foo.txt', storeDir: params.publish_dir)
        .set { collected_file }

    bar(collected_file)
}
