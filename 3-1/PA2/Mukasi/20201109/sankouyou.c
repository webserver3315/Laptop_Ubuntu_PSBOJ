void runPipedCommands(cmdLine* command, char* userInput) {
    int numPipes = countPipes(userInput);

    int status;
    int i = 0, j = 0;

    pid_t pid;

    int pipefds[2 * numPipes];

    for (i = 0; i < 2 * (numPipes); i++) {
        if (pipe(pipefds + i * 2) < 0) {
            perror("pipe");
            exit(EXIT_FAILURE);
        }
    }

    while (command) {
        pid = fork();
        if (pid == 0) {
            //if not first command
            if (j != 0) {
                if (dup2(pipefds[(j - 1) * 2], 0) < 0) {
                    perror(" dup2");  ///j-2 0 j+1 1
                    exit(EXIT_FAILURE);
                    //printf("j != 0  dup(pipefd[%d], 0])\n", j-2);
                }
                //if not last command
                if (command->next) {
                    if (dup2(pipefds[j * 2 + 1], 1) < 0) {
                        perror("dup2");
                        exit(EXIT_FAILURE);
                    }
                }

                for (i = 0; i < 2 * numPipes; i++) {
                    close(pipefds[i]);
                }

                if (execvp(*command->arguments, command->arguments) < 0) {
                    perror(*command->arguments);
                    exit(EXIT_FAILURE);
                }
            } else if (pid < 0) {
                perror("error");
                exit(EXIT_FAILURE);
            }

            command = command->next;
            j++;
        }
        for (i = 0; i < 2 * numPipes; i++) {
            close(pipefds[i]);
            puts("closed pipe in parent");
        }

        while (waitpid(0, 0, 0) <= 0)
            ;
    }
}

/******/
/* parent creates all needed pipes at the start */
for (i = 0; i < num - pipes; i++) {
    if (pipe(pipefds + i * 2) < 0) {
        perror and exit
    }
}

commandc = 0;
while (command) {
    pid = fork();
    if (pid == 0) {
        /* child gets input from the previous command,
            if it's not the first command */
        if (not first command) {
            if (dup2(pipefds[(commandc - 1) * 2], 0) <) {
                perror and exit;
            }
        }
        /* child outputs to next command, if it's not
            the last command */
        if (not last command) {
            if (dup2(pipefds[commandc * 2 + 1], 1) < 0) {
                perror and exit;
            }
        }
        close all pipe - fds
                             execvp
                                 perror and exit
    } else if (pid < 0) {
        perror and exit
    }
    cmd = cmd->next
              commandc++
}

/* parent closes all of its copies at the end */
for (i = 0; i < 2 * num - pipes; i++) {
    close(pipefds[i]);
}

/************************************************************************************/
for
    cmd in cmds if there is a next cmd
        pipe(new_fds)
            fork
        if child
        if there is a previous cmd
        dup2(old_fds[0], 0);
close(old_fds[0]);
close(old_fds[1]);
if there
    is a next cmd
        close(new_fds[0]);
dup2(new_fds[1], 1);
close(new_fds[1]);
exec cmd || die else if there is a previous cmd
                close(old_fds[0])
                    close(old_fds[1]) if there is a next cmd
    old_fds = new_fds if there are multiple cmds
    close(old_fds[0])
        close(old_fds[1])
