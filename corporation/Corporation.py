from sys import stdin
import threading
from math import gcd
from fractions import Fraction

def main():
    import sys
    sys.setrecursionlimit(1 << 25)
    num_employees, num_queries = map(int, stdin.readline().split())
    employee_salaries = list(map(int, stdin.readline().split()))

    class SegmentTreeNode:
        __slots__ = ['start', 'end', 'left_child', 'right_child', 'total_salary', 'total_happiness', 'length',
                     'pending_assignment', 'pending_increment', 'salary_value', 'happiness_value']
        def __init__(self, start, end):
            self.start = start
            self.end = end
            self.left_child = None
            self.right_child = None
            self.total_salary = 0
            self.total_happiness = 0
            self.length = end - start + 1
            self.pending_assignment = None
            self.pending_increment = 0
            self.salary_value = None
            self.happiness_value = None
            if start == end:
                self.total_salary = employee_salaries[start-1]
                self.total_happiness = 0
                self.salary_value = employee_salaries[start-1]
                self.happiness_value = 0
            else:
                mid = (start + end) // 2
                self.left_child = SegmentTreeNode(start, mid)
                self.right_child = SegmentTreeNode(mid+1, end)
                self.push_up()

        def push_up(self):
            self.total_salary = self.left_child.total_salary + self.right_child.total_salary
            self.total_happiness = self.left_child.total_happiness + self.right_child.total_happiness
            self.salary_value = None  # Not homogeneous
            self.happiness_value = None  # Not homogeneous

        def push_down(self):
            if self.pending_assignment is not None:
               
                self.left_child.apply_assignment(self.pending_assignment)
                self.right_child.apply_assignment(self.pending_assignment)
                self.pending_assignment = None
            if self.pending_increment != 0:
               
                self.left_child.apply_increment(self.pending_increment)
                self.right_child.apply_increment(self.pending_increment)
                self.pending_increment = 0

        def apply_assignment(self, value):
           
            self.total_salary = self.length * value
           
            if self.salary_value is not None:
             
                s = self.salary_value
                happiness_change = self.length * sign(value - s)
                self.total_happiness += happiness_change
                self.happiness_value += sign(value - s)
            else:
               
               
                self.salary_value = value
                self.happiness_value = 0  
              
              
                self.push_down()
                self.left_child.apply_assignment(value)
                self.right_child.apply_assignment(value)
                self.push_up()
                return
            self.pending_assignment = value
            self.pending_increment = 0
            
            self.salary_value = value

        def apply_increment(self, value):
          
            self.total_salary += self.length * value
            
            happiness_change = self.length * sign(value)
            self.total_happiness += happiness_change
            if self.salary_value is not None:
              
                self.salary_value += value
                self.happiness_value += sign(value)
            else:
                
                self.push_down()
                self.left_child.apply_increment(value)
                self.right_child.apply_increment(value)
                self.push_up()
                return
            if self.pending_assignment is not None:
                self.pending_assignment += value
            else:
                self.pending_increment += value

        def range_update_assignment(self, start, end, value):
            if self.end < start or self.start > end:
                return
            if start <= self.start and self.end <= end:
                self.apply_assignment(value)
            else:
                self.push_down()
                self.left_child.range_update_assignment(start, end, value)
                self.right_child.range_update_assignment(start, end, value)
                self.push_up()

        def range_update_increment(self, start, end, value):
            if self.end < start or self.start > end:
                return
            if start <= self.start and self.end <= end:
                self.apply_increment(value)
            else:
                self.push_down()
                self.left_child.range_update_increment(start, end, value)
                self.right_child.range_update_increment(start, end, value)
                self.push_up()

        def range_query_salary(self, start, end):
            if self.end < start or self.start > end:
                return 0
            if start <= self.start and self.end <= end:
                return self.total_salary
            else:
                self.push_down()
                return self.left_child.range_query_salary(start, end) + self.right_child.range_query_salary(start, end)

        def range_query_happiness(self, start, end):
            if self.end < start or self.start > end:
                return 0
            if start <= self.start and self.end <= end:
                return self.total_happiness
            else:
                self.push_down()
                return self.left_child.range_query_happiness(start, end) + self.right_child.range_query_happiness(start, end)

    def sign(x):
        if x > 0:
            return 1
        elif x < 0:
            return -1
        else:
            return 0

    segment_tree = SegmentTreeNode(1, num_employees)
    for _ in range(num_queries):
        query = stdin.readline().split()
        if not query:
            continue
        query_type = int(query[0])
        if query_type == 0:
            
            _, start, end, value = query
            start = int(start)
            end = int(end)
            value = int(value)
            segment_tree.range_update_assignment(start, end, value)
        elif query_type == 1:
            
            _, start, end, value = query
            start = int(start)
            end = int(end)
            value = int(value)
            segment_tree.range_update_increment(start, end, value)
        elif query_type == 2:
           
            _, start, end = query
            start = int(start)
            end = int(end)
            total_salary = segment_tree.range_query_salary(start, end)
            length = end - start + 1
            frac = Fraction(total_salary, length)
            print(f"{frac.numerator}/{frac.denominator}")
        elif query_type == 3:
            
            _, start, end = query
            start = int(start)
            end = int(end)
            total_happiness = segment_tree.range_query_happiness(start, end)
            length = end - start + 1
            frac = Fraction(total_happiness, length)
            print(f"{frac.numerator}/{frac.denominator}")

threading.Thread(target=main).start()