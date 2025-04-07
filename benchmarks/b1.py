import numpy as np
import time
from utils import load_image, bprint

def b1():
    img = load_image("assets/banner.png")

    start_time = time.time()
    bprint(img[0][0][0])
    img = img + 70
    bprint(img[0][0][0])

    # img = img * 0.5 + 20
    # img = img.transpose(1, 0, 2)

    end_time = time.time()
    elapsed_time = end_time - start_time

    bprint(f"Image processing completed in {elapsed_time:.7f} seconds.")
    return

if __name__ == "__main__":
    b1()