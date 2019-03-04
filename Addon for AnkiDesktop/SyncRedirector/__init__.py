from aqt import mw
from .SyncRedirector import SyncRedirector

config = mw.addonManager.getConfig(__name__)

sync_redirector = SyncRedirector(config["syncUrl"], config["msyncUrl"])

SyncRedirector.print_introduction()
sync_redirector.print_config()
SyncRedirector.print_restart_warning()

sync_redirector.reconfigure_anki_syncing()
