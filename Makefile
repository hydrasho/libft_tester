SRC_VALA = main.vala module.vala part1.vala part2.vala SupraLeak.vala SupraTest.vala
LIB_VALA = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0
LIB = $$(pkg-config --libs gmodule-2.0 gio-2.0) -lbsd -ldl
CFLAGS = $$(pkg-config --cflags gmodule-2.0 gio-2.0) -O2 -w
SRC_C = $(SRC_VALA:.vala=.c) leak.c
OBJ = $(SRC_C:.c=.o)
NAME = test

# Color
GREEN = \033[32;1m
WHITE= \033[37;1m
YELLOW = \033[33;1m
NC = \033[0m


all: $(NAME)

$(NAME) : generate_c $(OBJ)
	@gcc $(OBJ) $(LIB) -o $(NAME)
	@echo -e "$(YELLOW)[ LINKING ]$(NC)"

%.o : %.c
	@gcc $(CFLAGS) $< -c -o $@
	@printf "$(WHITE)compiling $< >>> $@$(NC)\n"

generate_c: $(SRC_VALA)
	@valac --enable-experimental dllloader.vapi $(SRC_VALA) $(LIB_VALA) -C
	@echo -e "$(GREEN)[ Generation of all C Files ]$(NC)"

clean:
	rm -rf $(SRC_VALA:.vala=.c)
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all

run: all
	export LD_LIBRARY_PATH=./ && ./$(NAME)

run2:
	export LD_LIBRARY_PATH=./ && ./$(NAME)
