import os
from pyinotify import WatchManager, Notifier, ThreadedNotifier, EventsCodes, ProcessEvent
import pyinotify
from subprocess import call
wm = WatchManager()

mask = pyinotify.IN_CREATE | pyinotify.IN_MODIFY | pyinotify.IN_MOVED_TO

class PDir(ProcessEvent):
	def process_IN_CREATE(self, event):
		#print "Create {0}, {1}".format(event.path, event.name)
		if(event.name.endswith('.dot')):
			outName = event.name.replace('.dot','.png')
			print "Generating %s" % outName
			call(["dot", "-Tpng", os.path.join(event.path, event.name), '-o', os.path.join(event.path, outName)])

	def process_IN_MODIFY(self, event):
		#print "modify {0}, {1}".format(event.path, event.name)
		if(event.name.endswith('.dot')):
			outName = event.name.replace('.dot','.png')
			print "Recompiling %s" % outName
			call(["dot", "-Tpng", os.path.join(event.path, event.name), '-o', os.path.join(event.path, outName)])
	
	def process_IN_MOVED_TO(self, event):
		#print "modify {0}, {1}".format(event.path, event.name)
		if(event.name.endswith('.dot')):
			outName = event.name.replace('.dot','.png')
			print "Recompiling %s" % outName
			call(["dot", "-Tpng", os.path.join(event.path, event.name), '-o', os.path.join(event.path, outName)])

notifier = Notifier(wm, PDir())
wdd = wm.add_watch('.', mask, rec=True)


while True:
	try:
		notifier.process_events()
		if notifier.check_events():
			notifier.read_events()
	except KeyboardInterrupt:
		notifier.stop()
		break


