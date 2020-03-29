import math
import datetime as dt

class Node:
    def __init__(self, data = None):
        self.left = None
        self.right = None
        self.data = data

    def insert(self, data):
        # Compare the new value with the parent node
        if self.data:
            pass_start = data.aos
            pass_end = data.aos + dt.timedelta(seconds=data.duration_s)
            # Check if pass overlaping
            overlap_left = pass_start < self.data.aos + \
                dt.timedelta(seconds=self.data.duration_s) and \
                pass_start > self.data.aos
            overlap_right = pass_end > self.data.aos and \
                pass_end < self.data.aos + dt.timedelta(seconds=self.data.duration_s)
            if overlap_left or overlap_right:
                if data.max_elevation_deg > self.data.max_elevation_deg:
                    self.data = data
            elif data.aos < self.data.aos:
                if self.left is None:
                    self.left = Node(data)
                else:
                    self.left.insert(data)
            elif data.aos > self.data.aos:
                if self.right is None:
                    self.right = Node(data)
                else:
                    self.right.insert(data)
        else:
            self.data = data

    # Print the tree
    def PrintTree(self):
        if self.left:
            self.left.PrintTree()
        print('{0} {1} {2} {3} {4}'.format(self.data.aos.strftime("%H:%M %D"), \
        math.ceil(self.data.aos.timestamp()), math.ceil(self.data.max_elevation_deg), \
        math.ceil(self.data.duration_s), self.data.sate_id)),
        if self.right:
            self.right.PrintTree()