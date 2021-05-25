#!/usb/bin/env nextflow
nextflow.enable.dsl=2

process foo {
    tag "${name}"
    echo true
    cpus 1
    memory 500.MB
    container "opensuse/leap:latest"
    input:
        val(name)
        path(template_file)
    output:
        path("${name}.txt")
    """
    sha1sum ${template_file}
    cat ${template_file} > ${name}.txt
    echo ${name} >> ${name}.txt
    """
}

workflow {
    names = Channel.from(['Riri', 'Fifi', 'Loulou'])
    template_file = file("${baseDir}/assets/template.txt")
    foo(names, template_file)
}
