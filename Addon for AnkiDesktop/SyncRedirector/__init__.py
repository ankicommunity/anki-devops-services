import anki.sync
from aqt import mw

config = mw.addonManager.getConfig(__name__)


def main():
    sync_redirector = SyncRedirector(config["syncUrl"], config["msyncUrl"])

    SyncRedirector.print_introduction()
    sync_redirector.print_config()
    SyncRedirector.print_restart_warning()

    sync_redirector.reconfigure_anki_syncing()


class SyncRedirector:
    def __init__(self, configured_sync_url, configured_msync_url):
        """
        Expects urls ending with /sync and /msync or /sync/ and /msync/.
        """
        self.configured_sync_url = configured_sync_url
        self.configured_msync_url = configured_msync_url

    def print_introduction():
        print("== SyncRedirector Addon ==")

    def print_config(self):
        print("/sync URL: " + self.configured_sync_url)
        print("/msync URL: " + self.configured_msync_url)

    def print_restart_warning():
        print(
            "WARNING: please restart Anki after configuring this addon in order to the changes take effect!"
        )

    def reconfigure_anki_syncing(self):
        """
        Expects urls ending with /sync and /msync or /sync/ and /msync/.
        """
        print("Configuring Anki to sync against custom servers...")

        anki.sync.SYNC_BASE = self._parse_sync_url_for_anki_desktop()
        anki.sync.SYNC_MEDIA_BASE = self._parse_msync_url_for_anki_desktop()

    def _parse_sync_url_for_anki_desktop(self):
        """
        Expects url ending with /sync or /sync/
        """
        return url_ending_with_slash(self.configured_sync_url.strip("/sync")) + "%s"

    def _parse_msync_url_for_anki_desktop(self):
        """
        Expects url ending with /msync or /msync/
        """
        return url_ending_with_slash(self.configured_msync_url) + "%s"


def url_ending_with_slash(url):
    if url[-1] == "/":
        return url
    else:
        return url + "/"


main()
