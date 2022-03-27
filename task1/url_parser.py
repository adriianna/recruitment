import pandas as pd
import re
from pathlib import Path

script_path = Path(__file__).parent.absolute()
input_file = script_path / 'task1_input.tsv'
input_file.exists()

df = pd.read_csv(input_file, sep='\t')

tag_map = {
    'a_bucket': 'ad_bucket',
    'a_type': 'ad_type',
    'a_source': 'ad_source',
    'a_v': 'schema_version',
    'a_g_campaignid': 'ad_campaign_id',
    'a_g_keyword': 'ad_keyword',
    'a_g_adgroupid': 'ad_group_id',
    'a_g_creative': 'ad_creative'
}


def parse_value(url, tag):
    pattern = rf"{tag}=([^&]*)"
    try:
        search_result = re.search(pattern, url)
        search_value = search_result.group(1)
        return search_value
    except AttributeError:
        return ''


for key in tag_map:
    df[tag_map[key]] = df.apply(lambda row: parse_value(row['url'], key), axis=1)

df.to_csv(script_path / 'output.tsv', sep='\t')
