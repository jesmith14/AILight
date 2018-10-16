class Light:
    def __init__(self,color,intensity,type):
        self.color = color
        self.intensity = intensity
        self.type = type

    def increaseIntensity(self):
        return self.intensity*2

    def changeColor(self):
        self.color = 233