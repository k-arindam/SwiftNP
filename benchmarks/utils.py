import cv2

def load_image(image_path):
    """
    Load an image from the specified path.
    
    Args:
        image_path (str): The path to the image file.
    
    Returns:
        numpy.ndarray: The loaded image.
    """
    # Read the image using OpenCV
    image = cv2.imread(image_path)
    
    # Check if the image was loaded successfully
    if image is None:
        raise ValueError(f"Image not found at path: {image_path}")
    
    bprint(f"Image loaded from {image_path} with shape: {image.shape}")
    return image

def bprint(*args, **kwargs):
    """
    Custom print function to format output.
    
    Args:
        *args: Variable length argument list.
        **kwargs: Arbitrary keyword arguments.
    """
    print("----->>>", *args, **kwargs)