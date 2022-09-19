from tabulate import tabulate
import altair as alt
import pandas as pd
import datetime


def tabulate_json(json_data, items):
    table_data = dict()

    for i in items:
        table_data[i] = list()

    for m in json_data:
        for k in table_data:
            # will have link+data if dict returned
            if isinstance(m[k], dict):
                table_data[k].append('Yes')

            # If none then no data
            elif m[k] is None:
                table_data[k].append('-')

            # If URL then something linked to field
            elif isinstance(m[k], str):
                if any(v in m[k] for v in ['http://', 'https://']):
                    table_data[k].append('Linked')
                else:
                    table_data[k].append(m[k])

            # Fallback - add value as string
            else:
                table_data[k].append(str(m[k]))
    return table_data

'''
tabulate_endpoint(api.models, ['id', 'supplier_id', 'model_id', 'version_id'])
tabulate_endpoint(api.portfolios, ['id', 'name', 'location_file', 'accounts_file', 'reinsurance_info_file', 'reinsurance_scope_file'])
tabulate_endpoint(api.analyses, ['id', 'name', 'model', 'portfolio', 'status', 'input_file', 'output_file', 'run_log_file'])
'''
def tabulate_endpoint(endpoint_obj, items, tablefmt='html'):
    data = tabulate_json(endpoint_obj.get().json(), items)
    return tabulate(data, headers=items, tablefmt=tablefmt)

def tabulate_analysis(json_list,  tablefmt='html', cols=None):
    if not cols:
        cols = [
            'id',
            'name',
            'model',
            'portfolio',
            'status',
            'input_file',
            'output_file',
            'lookup_chunks',
            'analysis_chunks'
        ]
    return tabulate(tabulate_json(json_list, cols), headers=cols, tablefmt=tablefmt)

def tabulate_portfolio(json_list,  tablefmt='html', cols=None):
    if not cols:
        cols =  [
            'id',
            'name',
            'location_file',
            'accounts_file',
            'reinsurance_info_file',
            'reinsurance_scope_file'
        ]
    return tabulate(tabulate_json(json_list, cols), headers=cols, tablefmt=tablefmt)


# --- Task Gantt chat plots -------------------------------------------------- #



def relative_time_secs(starting_point, timestamp, timestamp_format="%Y-%m-%dT%H:%M:%S.%fZ"):
    t_start = datetime.datetime.strptime(starting_point, timestamp_format)
    t_end = datetime.datetime.strptime(timestamp, timestamp_format)
    t_dur = t_end - t_start
    return round(t_dur.total_seconds(), 2)


def plot_subtasks(sub_task_list, plot_width=1000):
    subtasks = sorted(sub_task_list, key=lambda subtask: subtask['id'])
    relative_start = subtasks[0]['start_time']

    task_data = pd.DataFrame(
        [{
            'id':t['id'],
            'sub-task': t['slug'],
            'start': relative_time_secs(relative_start, t['start_time']),
            'end': relative_time_secs(relative_start, t['end_time']),
            "duration": relative_time_secs(t['start_time'], t['end_time'])
         } for t in subtasks ])

    gantt = alt.Chart(task_data).mark_bar().encode(
        x='start',
        x2='end',
        y=alt.Y('sub-task:N', sort=alt.EncodingSortField(field="id"))
    )

    text = gantt.mark_text(
        baseline='middle',
        align='center',
        color='white',
        dx=30
    ).encode(text='duration:N')

    gantt = (gantt+text).properties(width=1000)#.interactive()
    return gantt
