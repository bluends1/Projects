import pygame as pg

pg.init()
pg.font.init()
sfont = pg.font.SysFont("Consolas", 40)
rfont = pg.font.SysFont("Consolas", 25)

sw = 800
sh = 600
gridsize = 35
sqsize = 15

def drawgrid(gridsize):
    grid = []
    for y in range(gridsize):
        grid.append([])
        for x in range(gridsize):
            grid[y].append(".")
    return grid

def hcost(x, y, ex, ey):
    # find distance to end point
    return abs(ex - x)**2 + abs(ey - y)**2

def pathfind(grid):
    sx, sy, ex, ey = 0, 0, 0, 0
    iterations = 3000 # how many time it is allowed to run
    # find start point and end point cood
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] == "S":
                sx = x
                sy = y
            elif grid[y][x] == "E":
                ex = x
                ey = y

    opensq = []
    closedsq = []
    found = False
    #add starting point to open
    opensq.append([sx, sy, 0, hcost(sx, sy, ex, ey)])

    while opensq and iterations > 0:
        # find node with smallest f in opensq
        q = opensq[0]
        if len(opensq) > 1:
            for sq in opensq:
                # check for f
                if q[2] + q[3] > sq[2] + sq[3]:
                    q = sq
                elif q[2] + q[3] == sq[2] + sq[3]:
                    # check for lowest h if f is same
                    if q[3] >= sq[3]:
                        q = sq
                    else:
                        pass
                else:
                    pass
         # found q, now pop q off opensq
        opensq.pop(opensq.index(q))
        # check if the 8 new directions is the goal
        if len(grid) > q[1] >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1]][q[0] + 1] == "E":
            found = True
            break
        elif len(grid) > q[1] >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1]][q[0] - 1] == "E":
            found = True
            break
        elif len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] >= 0 and grid[q[1] + 1][q[0]] == "E":
            found = True
            break
        elif len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] >= 0 and grid[q[1] - 1][q[0]] == "E":
            found = True
            break
        elif len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1] + 1][q[0] + 1] == "E":
            found = True
            break
        elif len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1] - 1][q[0] - 1] == "E":
            found = True
            break
        elif len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1] + 1][q[0] - 1] == "E":
            found = True
            break
        elif len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1] - 1][q[0] + 1] == "E":
            found = True
            break
        # and look for 8 directions of q and add them into opensq
        if len(grid) > q[1] >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1]][q[0] + 1] == ".":
            opensq.append([q[0] + 1, q[1], q[2] + 1, hcost(q[0] + 1, q[1], ex, ey)])
        if len(grid) > q[1] >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1]][q[0] - 1] == ".":
            opensq.append([q[0] - 1, q[1], q[2] + 1, hcost(q[0] - 1, q[1], ex, ey)])
        if len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] >= 0 and grid[q[1] + 1][q[0]] == ".":
            opensq.append([q[0], q[1] + 1, q[2] + 1, hcost(q[0], q[1] + 1, ex, ey)])
        if len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] >= 0 and grid[q[1] - 1][q[0]] == ".":
            opensq.append([q[0], q[1] - 1, q[2] + 1, hcost(q[0], q[1] - 1, ex, ey)])
        # diagonals
        if len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1] + 1][q[0] + 1] == ".":
            opensq.append([q[0] + 1, q[1] + 1, q[2] + 1, hcost(q[0] + 1, q[1] + 1, ex, ey)])
        if len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1] - 1][q[0] - 1] == ".":
            opensq.append([q[0] - 1, q[1] - 1, q[2] + 1, hcost(q[0] - 1, q[1] - 1, ex, ey)])
        if len(grid) > q[1] + 1 >= 0 and len(grid) > q[0] - 1 >= 0 and grid[q[1] + 1][q[0] - 1] == ".":
            opensq.append([q[0] - 1, q[1] + 1, q[2] + 1, hcost(q[0] - 1, q[1] + 1, ex, ey)])
        if len(grid) > q[1] - 1 >= 0 and len(grid) > q[0] + 1 >= 0 and grid[q[1] - 1][q[0] + 1] == ".":
            opensq.append([q[0] + 1, q[1] - 1, q[2] + 1, hcost(q[0] + 1, q[1] - 1, ex, ey)])
        # finally slap q into closedsq
        closedsq.append(q)
        # set colours for everything
        for sq in opensq:
            grid[sq[1]][sq[0]] = "O"
        for sq in closedsq:
            grid[sq[1]][sq[0]] = "C"
        grid[sy][sx] = "S"
        grid[ey][ex] = "E"

        iterations -= 1

    if iterations <= 0:
        return False

    if found:
        closedsq.append(q)
        grid[q[1]][q[0]] = "C"
        # scan for 4 directions starting from the end and look for the shortest g
        pa = q
        selector = []
        grid[q[1]][q[0]] = "P"
        while pa[2] >= 1:
            for sq in closedsq:
                if len(grid) > pa[1] >= 0 and len(grid) > pa[0] + 1 >= 0 and grid[pa[1]][pa[0] + 1] == "C" and pa[1] == sq[1] and pa[0] + 1 == sq[0]:
                    selector.append([pa[0] + 1, pa[1], sq[2], hcost(pa[0] + 1, pa[1], ex, ey)])
                if len(grid) > pa[1] >= 0 and len(grid) > pa[0] - 1 >= 0 and grid[pa[1]][pa[0] - 1] == "C" and pa[1] == sq[1] and pa[0] - 1 == sq[0]:
                    selector.append([pa[0] - 1, pa[1], sq[2], hcost(pa[0] - 1, pa[1], ex, ey)])
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] >= 0 and grid[pa[1] + 1][pa[0]] == "C" and pa[1] + 1 == sq[1] and pa[0] == sq[0]:
                    selector.append([pa[0], pa[1] + 1, sq[2], hcost(pa[0], pa[1] + 1, ex, ey)])
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] >= 0 and grid[pa[1] - 1][pa[0]] == "C" and pa[1] - 1 == sq[1] and pa[0] == sq[0]:
                    selector.append([pa[0], pa[1] - 1, sq[2], hcost(pa[0], pa[1] - 1, ex, ey)])
                # diagonals
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] + 1 >= 0 and grid[pa[1] + 1][pa[0] + 1] == "C" and pa[1] + 1 == sq[1] and pa[0] + 1 == sq[0]:
                    selector.append([pa[0] + 1, pa[1] + 1, sq[2], hcost(pa[0] + 1, pa[1] + 1, ex, ey)])
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] - 1 >= 0 and grid[pa[1] - 1][pa[0] - 1] == "C" and pa[1] - 1 == sq[1] and pa[0] - 1 == sq[0]:
                    selector.append([pa[0] - 1, pa[1] - 1, sq[2], hcost(pa[0] - 1, pa[1] - 1, ex, ey)])
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] - 1 >= 0 and grid[pa[1] + 1][pa[0] - 1] == "C" and pa[1] + 1 == sq[1] and pa[0] - 1 == sq[0]:
                    selector.append([pa[0] - 1, pa[1] + 1, sq[2], hcost(pa[0] - 1, pa[1] + 1, ex, ey)])
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] + 1 >= 0 and grid[pa[1] - 1][pa[0] + 1] == "C" and pa[1] - 1 == sq[1] and pa[0] + 1 == sq[0]:
                    selector.append([pa[0] + 1, pa[1] - 1, sq[2], hcost(pa[0] + 1, pa[1] - 1, ex, ey)])
            print("=====")
            print(selector)
            pa = selector[0]
            for sq in selector:
                if pa[2] > sq[2]:
                    pa = sq
                else:
                    pass
            if pa[2] <= 2:
                print(pa[2])
                #check if 8 sides is the exit
                if len(grid) > pa[1] >= 0 and len(grid) > pa[0] + 1 >= 0 and pa[1] == sy and pa[0] + 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] >= 0 and len(grid) > pa[0] - 1 >= 0 and pa[1] == sy and pa[0] - 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] >= 0 and pa[1] + 1 == sy and pa[0] == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] >= 0 and pa[1] - 1 == sy and pa[0] == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                # diagonals
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] + 1 >= 0 and pa[1] + 1 == sy and pa[0] + 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] - 1 >= 0 and pa[1] - 1 == sy and pa[0] - 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] + 1 >= 0 and len(grid) > pa[0] - 1 >= 0 and pa[1] + 1 == sy and pa[0] - 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                if len(grid) > pa[1] - 1 >= 0 and len(grid) > pa[0] + 1 >= 0 and pa[1] - 1 == sy and pa[0] + 1 == sx:
                    grid[pa[1]][pa[0]] = "P"
                    return True
                pass
            grid[pa[1]][pa[0]] = "P"
            selector.clear()
        return True

def display(window, grid, boxtype, found):
    #draw map
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] == ".":
                pg.draw.rect(window, (200,200,200), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "X":
                pg.draw.rect(window, (30, 30, 30), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "S":
                pg.draw.rect(window, (20, 200, 20), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "E":
                pg.draw.rect(window, (200, 20, 20), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "O":
                pg.draw.rect(window, (125, 179, 245), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "C":
                pg.draw.rect(window, (98, 33, 150), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
            elif grid[y][x] == "P":
                pg.draw.rect(window, (255, 255, 38), (x * (sqsize + 1) + sqsize, y * (sqsize + 1) + sqsize, sqsize, sqsize))
    # UI
    if Xhover:
        pg.draw.rect(window, (120,120,120), (600, 30, 50, 35))
    else:
        if boxtype == "X":
            pg.draw.rect(window, (20, 200, 20), (600, 30, 50, 35))
        else:
            pg.draw.rect(window, (160,160,160), (600, 30, 50, 35))
    if Shover:
        pg.draw.rect(window, (120,120,120), (660, 30, 50, 35))
    else:
        if boxtype == "S":
            pg.draw.rect(window, (20, 200, 20), (660, 30, 50, 35))
        else:
            pg.draw.rect(window, (160,160,160), (660, 30, 50, 35))
    if Ehover:
        pg.draw.rect(window, (120,120,120), (720, 30, 50, 35))
    else:
        if boxtype == "E":
            pg.draw.rect(window, (20, 200, 20), (720, 30, 50, 35))
        else:
            pg.draw.rect(window, (160,160,160), (720, 30, 50, 35))
    if Rhover:
        pg.draw.rect(window, (120,120,120), (600, 85, 170, 50))
    else:
        pg.draw.rect(window, (160,160,160), (600, 85, 170, 50))
    if Phover:
        pg.draw.rect(window, (120,120,120), (600, 145, 170, 50))
    else:
        pg.draw.rect(window, (160,160,160), (600, 145, 170, 50))
    Xtext = sfont.render("X", False, (0,0,0))
    Stext = sfont.render("S", False, (0,0,0))
    Etext = sfont.render("E", False, (0,0,0))
    Rtext = rfont.render("Reset Board", False, (0,0,0))
    Ptext = rfont.render(" Find Path", False, (0,0,0))

    if found:
        f1text = rfont.render("Path found!", False, (180, 180, 180))
        window.blit(f1text, (608, 210))
    elif found == False:
        f2text = rfont.render("Failed...", False, (180, 180, 180))
        window.blit(f2text, (608, 210))
    else:
        pg.draw.rect(window, (0, 0, 0), (608, 210, 170, 200))

    window.blit(Xtext, (614, 30))
    window.blit(Stext, (674, 30))
    window.blit(Etext, (734, 30))
    window.blit(Rtext, (608, 100))
    window.blit(Ptext, (608, 160))

    pg.display.update()

def main():
    global Xhover, Shover, Ehover, Rhover, Phover
    window = pg.display.set_mode((sw, sh))
    clock = pg.time.Clock()
    grid = drawgrid(gridsize)
    sx, sy, ex, ey = 0,0,0,0
    boxtype = "X"
    Sready = False
    Eready = False
    Xhover = False
    Shover = False
    Ehover = False
    Rhover = False
    Phover = False
    found = None

    run = True
    while run:
        clock.tick(60)
        for event in pg.event.get():
            if event.type == pg.QUIT:
                run = False
                pg.quit()
                quit()
            if boxtype == "X":
                if event.type == pg.MOUSEMOTION and event.buttons[0]:
                    for y in range(len(grid)):
                        for x in range(len(grid[y])):
                            if x * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[0] >= x * (sqsize + 1) + sqsize and \
                                    y * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[1] >= y * (sqsize + 1) + sqsize:
                                x = pg.mouse.get_pos()[0] // (sqsize + 1) - 1
                                y = pg.mouse.get_pos()[1] // (sqsize + 1) - 1
                                grid[y][x] = boxtype

            if boxtype == "S":
                if event.type == pg.MOUSEBUTTONDOWN:
                    for y in range(len(grid)):
                        for x in range(len(grid[y])):
                            if x * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[0] >= x * (
                                    sqsize + 1) + sqsize and \
                                    y * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[1] >= y * (
                                    sqsize + 1) + sqsize:
                                x = pg.mouse.get_pos()[0] // (sqsize + 1) - 1
                                y = pg.mouse.get_pos()[1] // (sqsize + 1) - 1
                                grid[sy][sx] = "."
                                if grid[y][x] != "E":
                                    grid[y][x] = boxtype
                                sx = x
                                sy = y
                                Sready = True

            if boxtype == "E":
                if event.type == pg.MOUSEBUTTONDOWN:
                    for y in range(len(grid)):
                        for x in range(len(grid[y])):
                            if x * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[0] >= x * (
                                    sqsize + 1) + sqsize and \
                                    y * (sqsize + 1) + (sqsize * 2) >= pg.mouse.get_pos()[1] >= y * (
                                    sqsize + 1) + sqsize:
                                x = pg.mouse.get_pos()[0] // (sqsize + 1) - 1
                                y = pg.mouse.get_pos()[1] // (sqsize + 1) - 1
                                grid[ey][ex] = "."
                                if grid[y][x] != "S":
                                    grid[y][x] = boxtype
                                ex = x
                                ey = y
                                Eready = True


            if 650 >= pg.mouse.get_pos()[0] >= 600 and 65 >= pg.mouse.get_pos()[1] >= 30:
                if boxtype != "X":
                    Xhover = True
                    if event.type == pg.MOUSEBUTTONDOWN:
                        boxtype = "X"
                        Xhover = False
            else:
                Xhover = False
            if 710 >= pg.mouse.get_pos()[0] >= 660 and 65 >= pg.mouse.get_pos()[1] >= 30:
                if boxtype != "S":
                    Shover = True
                    if event.type == pg.MOUSEBUTTONDOWN:
                        boxtype = "S"
                        Shover = False
            else:
                Shover = False
            if 770 >= pg.mouse.get_pos()[0] >= 720 and 65 >= pg.mouse.get_pos()[1] >= 30:
                if boxtype != "E":
                    Ehover = True
                    if event.type == pg.MOUSEBUTTONDOWN:
                        boxtype = "E"
                        Ehover = False
            else:
                Ehover = False
            if 770 >= pg.mouse.get_pos()[0] >= 600 and 135 >= pg.mouse.get_pos()[1] >= 85:
                    Rhover = True
                    if event.type == pg.MOUSEBUTTONDOWN:
                        for y in range(len(grid)):
                            for x in range(len(grid[y])):
                                grid[y][x] = "."
                                Sready = False
                                Eready = False
                                found = None
            else:
                Rhover = False
            if 770 >= pg.mouse.get_pos()[0] >= 600 and 195 >= pg.mouse.get_pos()[1] >= 145:
                    Phover = True
                    if event.type == pg.MOUSEBUTTONDOWN:
                        found = pathfind(grid)
            else:
                Phover = False

            keys = pg.key.get_pressed()
            if keys[pg.K_p]:
                print("===================")
                for y in grid:
                    print(*y)

        display(window, grid, boxtype, found)

if __name__ == "__main__":
    main()