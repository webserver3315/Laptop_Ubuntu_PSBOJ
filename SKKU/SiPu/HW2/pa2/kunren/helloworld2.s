.text

    .global main

main:

        # write our string to stdout.

        movl    $len,%edx       # third argument: message length.
        movl    $msg,%ecx       # second argument: pointer to message to write.
        movl    $1,%ebx	        # first argument: file handle (stdout).
        movl    $1,%eax	        # system call number (sys_write).
        syscall

        # and exit.

        movl    $0,%ebx         # first argument: exit code.
        movl    $60,%eax         # system call number (sys_exit).
        syscall

.data

msg:
        .string  "Hello, world!\n"      # the string to print.
        len = 13                  # length of the string.

