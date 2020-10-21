import nice.curses;


class Dino
{
	Curses curses;

	this()
	{
		Curses.Config cfg = {
			cursLevel: 0,
		};

		curses = new Curses(cfg);
		curses.stdscr.timeout(0);
	}

	void start()
	{
		while (true)
		{
			try
			{
				const key = curses.stdscr.getch();

				switch (key)
				{
					case 'q':
						return;
					default:
						break;
				}
			}
			catch (NCException e) {}

			draw();
			refresh();
		}
	}

	void draw()
	{
		curses.stdscr.clear();

		draw_terrain();
		draw_bush();
		draw_dino();
	}

	void draw_terrain()
	{

	}

	void draw_bush()
	{

	}

	void draw_dino()
	{

	}

	void refresh()
	{
		curses.stdscr.refresh();
		curses.update();
	}
}


void main()
{
	auto dino = new Dino;
	dino.start();
}
