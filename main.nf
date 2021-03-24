#!/usb/bin/env nextflow
nextflow.enable.dsl=2

process foo {
    cpus 1
    memory 500.MB
    container "opensuse/leap:latest"
    cache 'lenient'
    input:
        val(name)
        path(template_file)
    output:
        path("${name}.txt")
    """
    cat ${template_file} > ${name}.txt
    echo ${name} >> ${name}.txt
    """
}

workflow {
    names = Channel.from(['Riri', 'Fifi', 'Loulou'])
    template_file = file("${baseDir}/assets/template.txt")
    foo(names, template_file)
}
